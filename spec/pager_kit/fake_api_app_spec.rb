require "spec_helper"

require "rack/test"
require "pager_kit/fake_api_app"

RSpec.describe PagerKit::FakeApiApp do

  PAGER_DUTY_V2_JSON = "application/vnd.pagerduty+json;version=2"

  include Rack::Test::Methods

  let(:db) { {} }

  let(:app) do
    described_class.new!
  end

  before do
    app.db = db
    header "Accept", PAGER_DUTY_V2_JSON
    header "Content-Type", "application/json"
  end

  def body_json
    MultiJson.load(last_response.body)
  end

  context "fresh" do

    describe "GET /collection" do

      before do
        get "/things"
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "returns PagerDuty JSON" do
        expect(last_response.content_type).to eq(PAGER_DUTY_V2_JSON)
      end

      it "returns an empty collection" do
        expect(body_json).to match_pact(
          "things" => []
        )
      end

      it "includes pagination details" do
        expect(body_json).to match_pact(
          "offset" => 0,
          "more" => false
        )
      end

    end

    describe "GET /collection/item" do

      before do
        get "/things/thing1"
      end

      it "fails with 404" do
        expect(last_response.status).to eq(404)
      end

    end

  end

  context "with existing data" do

    let(:db) do
      YAML.load(<<-DATA)
        things:
          T1:
            name: Thing One
          T2:
            name: Thing Two
      DATA
    end

    describe "GET /collection" do

      before do
        get "/things"
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "returns the data" do
        expect(body_json).to match_pact(
          "things" => [
            {
              "id" => "T1",
              "name" => "Thing One"
            },
            {
              "id" => "T2",
              "name" => "Thing Two"
            }
          ]
        )
      end

    end

    describe "GET /collection/item" do

      before do
        get "/things/T1"
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "returns data" do
        expect(body_json).to match_pact(
          "thing" => {
            "id" => "T1",
            "name" => "Thing One"
          }
        )
      end

    end

  end

end
