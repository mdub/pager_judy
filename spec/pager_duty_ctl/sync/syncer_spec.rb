require "spec_helper"

require "pager_duty_ctl/sync/syncer"

RSpec.describe PagerDutyCtl::Sync::Syncer do

  let(:state) do
    YAML.safe_load(<<-YAML)
      escalation_policies:
        EP123:
          name: myteam-24x7
    YAML
  end

  before do

  end

  let(:client) { nil }
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
        pending
        service = state.fetch("services").values.first
        expect(service).to match_pact(
          "name" => "myservice",
          "summary" => "My great service"
        )
      end

    end

  end

end
