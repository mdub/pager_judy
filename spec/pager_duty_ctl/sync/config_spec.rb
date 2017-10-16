require "spec_helper"

require "pager_duty_ctl/sync/config"

RSpec.describe PagerDutyCtl::Sync::Config do

  let(:config) { PagerDutyCtl::Sync::Config.new }

  def self.it_requires(fields)
    it "requires: #{fields.join(", ")}" do
      expect(subject.config_errors.keys).to include(*fields)
    end
  end

  describe ".escalation_policies[X]" do

    subject(:ep) { config.escalation_policies["whatever"] }

    it_requires %w(.summary)

  end

  describe ".services[X]" do

    subject(:service) { config.services["whatever"] }

    it_requires %w(.summary .escalation_policy.id)

  end

end
