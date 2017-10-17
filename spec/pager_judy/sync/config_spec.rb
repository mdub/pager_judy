require "spec_helper"

require "pager_judy/sync/config"

RSpec.describe PagerJudy::Sync::Config do

  let(:config) { PagerJudy::Sync::Config.new }

  def self.it_requires(fields)
    it "requires: #{fields.join(", ")}" do
      expect(subject.config_errors.keys).to include(*fields)
    end
  end

  describe ".escalation_policies[X]" do

    subject(:ep) { config.escalation_policies["whatever"] }

    it_requires %w(.description)

  end

  describe ".services[X]" do

    subject(:service) { config.services["whatever"] }

    it_requires %w(.description .escalation_policy.id)

  end

end
