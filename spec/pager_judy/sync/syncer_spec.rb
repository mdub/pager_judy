require "spec_helper"

require "pager_judy/sync/syncer"
require "pager_judy/api/client"
require "pager_judy/api/fake_api_app"

RSpec.describe PagerJudy::Sync::Syncer do

  let(:fake_pager_duty_app) do
    PagerJudy::API::FakeApp.new!.tap do |app|
      app.db = db
    end
  end

  before do
    ShamRack.at("test-api.pagerduty.com").mount(fake_pager_duty_app)
  end

  let(:db) do
    YAML.safe_load(<<-YAML)
      escalation_policies:
        EP123:
          name: myteam-24x7
      services:
        S42:
          name: existing-service
          summary: "My existing service"
          escalation_policy:
            id: EP123
    YAML
  end

  let(:client) { PagerJudy::API::Client.new("BOGUS_KEY", base_uri: "http://test-api.pagerduty.com/" ) }
  let(:config) { PagerJudy::Sync::Config.from([config_data]) }
  let(:syncer) { described_class.new(config: config, client: client) }

  describe "#sync" do

    before do
      syncer.sync
    end

    context "with a new service" do

      let(:config_data) do
        YAML.safe_load(<<-YAML)
          services:
            new-service:
              summary: "My new service"
              escalation_policy:
                id: EP123
        YAML
      end

      it "creates the service" do
        service_matcher = hash_including("name" => "new-service")
        expect(db.fetch("services").values).to include(service_matcher)
      end

      it "leaves existing services alone" do
        expect(db).to match_pact(
          "services" => {
            "S42" => {
              "name" => "existing-service",
              "summary" => "My existing service"
            }
          }
        )
      end

    end

    context "with a updated service" do

      let(:config_data) do
        YAML.safe_load(<<-YAML)
          services:
            existing-service:
              summary: "Updated summary"
              escalation_policy:
                id: EP123
        YAML
      end

      it "modifies to existing services" do
        expect(db).to match_pact(
          "services" => {
            "S42" => {
              "name" => "existing-service",
              "summary" => "Updated summary"
            }
          }
        )
      end

    end

  end

end
