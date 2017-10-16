require "clamp"
require "console_logger"
require "pager_judy/api/client"
require "pager_judy/cli/collection_behaviour"
require "pager_judy/cli/item_behaviour"
require "pager_judy/sync"
require "pager_judy/version"

module PagerJudy
  module CLI

    class MainCommand < Clamp::Command

      option "--debug", :flag, "enable debugging", :attribute_name => :debug

      option "--version", :flag, "display version" do
        puts PagerJudy::VERSION
        exit 0
      end

      option "--api-key", "KEY", "PagerDuty API key",
             :environment_variable => "PAGER_DUTY_API_KEY"

      subcommand ["escalation-policy", "ep"], "Display escalation policy" do

        parameter "ID", "escalation_policy ID"

        include ItemBehaviour

        def item
          client.escalation_policies[id]
        end

      end

      subcommand ["escalation_policies", "eps"], "Display escalation policies" do

        option %w[-q --query], "FILTER", "name filter"

        include CollectionBehaviour

        private

        def collection
          client.escalation_policies.with(:query => query)
        end

      end

      subcommand "schedule", "Display schedule" do

        parameter "ID", "schedule ID"

        include ItemBehaviour

        def item
          client.schedules[id]
        end

      end

      subcommand "schedules", "Display schedules" do

        option %w[-q --query], "FILTER", "name filter"

        include CollectionBehaviour

        private

        def collection
          client.schedules.with(:query => query)
        end

      end

      subcommand "service", "Display service" do

        parameter "ID", "service ID"

        include ItemBehaviour

        def item
          client.services[id]
        end

      end

      subcommand "services", "Display services" do

        option %w[-q --query], "FILTER", "name filter"
        option %w[--team], "ID", "team ID"

        include CollectionBehaviour

        private

        def collection
          client.services.with("query" => query, "team_ids[]" => team)
        end

      end

      subcommand "team", "Display team" do

        parameter "ID", "team ID"

        include ItemBehaviour

        def item
          client.teams[id]
        end

      end

      subcommand "teams", "Display teams" do

        option %w[-q --query], "FILTER", "name filter"

        include CollectionBehaviour

        private

        def collection
          client.teams.with(:query => query)
        end

      end

      subcommand "configure", "Apply config" do

        parameter "SOURCE", "config file"

        def execute
          config = PagerJudy::Sync::Config.from(source)
        end

      end

      def run(*args)
        super(*args)
      rescue PagerJudy::API::HttpError => e
        signal_error e.message
      end

      private

      def client
        signal_error "no --api-key provided" unless api_key
        HTTPI.log = false
        @client ||= PagerJudy::API::Client.new(api_key, logger: logger)
      end

      def logger
        @logger ||= ConsoleLogger.new(STDERR, debug?)
      end

    end

  end
end
