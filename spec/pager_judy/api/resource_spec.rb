require "spec_helper"

require "pager_judy/api/fake_api_app"
require "pager_judy/api/resource"

RSpec.describe PagerJudy::API::Resource do

  let(:fake_pager_duty_app) do
    PagerJudy::API::FakeApp.new!.tap do |app|
      app.db = db
    end
  end

  before do
    ShamRack.at("test-api.pagerduty.com").mount(fake_pager_duty_app)
  end

  let(:log_output) { StringIO.new }
  let(:logger) { Logger.new(log_output) }

  def resource(path)
    uri = URI("http://test-api.pagerduty.com") + path
    described_class.new(api_key: "BOGUS_KEY", uri: uri, logger: logger)
  end

  let(:db) do
    YAML.safe_load(<<-YAML)
      things:
        T56:
          name: existing-service
          description: "Existing description"
    YAML
  end

  let(:new_data) do
    {
      "description" => "New description"
    }
  end

  describe "#get" do

    let(:result) { resource("things/T56").get }

    it "returns data" do
      expect(result).to match_pact(
        "thing" => {
          "name" => "existing-service"
        }
      )
    end

  end

  describe "#post" do

    let!(:result) { resource("things").post("thing" => new_data) }

    it "stores data" do
      expect(db.dig("things").values).to include(new_data)
    end

    it "returns data" do
      expect(result).to match_pact("thing" => new_data)
    end

  end

  describe "#put" do

    let!(:result) { resource("things/T56").put("thing" => new_data) }

    it "stores data" do
      expect(db).to match_pact(
        "things" => {
          "T56" => {
            "description" => "New description",
            "name" => "existing-service"
          }
        }
      )
    end

    it "returns data" do
      expect(result).to match_pact(
        "thing" => {
          "description" => "New description",
          "name" => "existing-service"
        }
      )
    end

  end

end
