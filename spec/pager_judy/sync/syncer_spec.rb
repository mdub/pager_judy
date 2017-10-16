require "spec_helper"

require "pager_judy/sync/syncer"
require "pager_judy/api/client"
require "pager_judy/api/fake_api_app"

RSpec.describe PagerJudy::Sync::Syncer do

  let(:fake_pager_duty_app) do
    PagerJudy::API::FakeApp.new!.tap do |app|
      app.db = state
    end
  end

  before do
    ShamRack.at("test-api.pagerduty.com").mount(fake_pager_duty_app)
  end

  let(:state) do
    YAML.safe_load(<<-YAML)
      escalation_policies:
        EP123:
          name: myteam-24x7
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
            myservice:
              summary: "My great service"
              escalation_policy:
                id: EP123
        YAML
      end

      it "creates the service" do
        service = state.fetch("services").values.first
        expect(service).to match_pact(
          "name" => "myservice",
          "summary" => "My great service",
          "escalation_policy" => {
            "id" => "EP123"
          }
        )
      end

    end

  end

end
