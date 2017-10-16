require "spec_helper"

require "pager_duty_ctl/sync/syncer"
require "pager_kit/client"
require "pager_kit/fake_api_app"

RSpec.describe PagerDutyCtl::Sync::Syncer do

  let(:fake_pager_duty_app) do
    PagerKit::FakeApiApp.new!.tap do |app|
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

  let(:client) { PagerKit::Client.new("BOGUS_KEY", base_uri: "http://test-api.pagerduty.com/" ) }
  let(:config) { PagerDutyCtl::Sync::Config.from([config_data]) }
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
