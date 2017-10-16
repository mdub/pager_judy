require "spec_helper"

require "pager_duty_ctl/sync/config"

RSpec.describe PagerDutyCtl::Sync::Config do

  let(:config) { PagerDutyCtl::Sync::Config.new }

  it "has escalation_policies" do
    expect(config).to respond_to(:escalation_policies)
  end

  describe "each escalation_policy" do

    let(:ep) { config.escalation_policies["whatever"] }

    it "has a (mandatory) summary" do
      expect(ep).to respond_to(:summary)
      expect(ep.config_errors.keys).to include(".summary")
    end

  end

  it "has services" do
    expect(config).to respond_to(:services)
  end

  describe "each service" do

    let(:service) { config.services["whatever"] }

    it "has a (mandatory) summary" do
      expect(service).to respond_to(:summary)
      expect(service.config_errors.keys).to include(".summary")
    end

  end

end
