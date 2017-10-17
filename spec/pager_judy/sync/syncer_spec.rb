require "spec_helper"

require "console_logger"
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
          description: "My existing service"
          escalation_policy:
            id: EP123
    YAML
  end

  let(:log_buffer) { StringIO.new }
  let(:log_output) { log_buffer.string }
  let(:logger) { ConsoleLogger.new(log_buffer, true) }

  let(:dry_run) { false }

  let(:client) do
    PagerJudy::API::Client.new(
      "BOGUS_KEY",
      base_uri: "http://test-api.pagerduty.com/",
      logger: logger,
      dry_run: dry_run
    )
  end

  let(:config) { PagerJudy::Sync::Config.from(config_data) }
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
              description: "My new service"
              escalation_policy:
                id: EP123
        YAML
      end

      it "creates the service" do
        service_matcher = hash_including(
          "name" => "new-service",
          "description" => "My new service",
          "escalation_policy" => {
            "id" => "EP123",
            "type" => "escalation_policy_reference"
          }
        )
        expect(db.fetch("services").values).to include(service_matcher)
      end

      it "leaves existing services alone" do
        expect(db).to match_pact(
          "services" => {
            "S42" => {
              "name" => "existing-service",
              "description" => "My existing service"
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
              description: "Updated description"
              escalation_policy:
                id: EP123
        YAML
      end

      it "modifies to existing services" do
        expect(db).to match_pact(
          "services" => {
            "S42" => {
              "name" => "existing-service",
              "description" => "Updated description"
            }
          }
        )
      end

    end

  end

  context "in :dry_run mode" do

    let(:dry_run) { true }

    describe "#sync" do

      before do
        syncer.sync
      end

      let(:config_data) do
        YAML.safe_load(<<-YAML)
          services:
            new-service:
              description: "My new service"
              escalation_policy:
                id: EP123
            existing-service:
              description: "Updated description"
              escalation_policy:
                id: EP123
        YAML
      end

      it "does not create new services" do
        service_matcher = hash_including("name" => "new-service")
        expect(db.fetch("services").values).not_to include(service_matcher)
      end

      it "leaves existing services alone" do
        expect(db).to match_pact(
          "services" => {
            "S42" => {
              "name" => "existing-service",
              "description" => "My existing service"
            }
          }
        )
      end

      it "logs the update/create operations (that it didn't perform)" do
        expect(log_output).to include('INFO: created service "new-service" [{new-service}]')
        expect(log_output).to include('INFO: updated service "existing-service" [S42]')
      end

    end

  end

end
