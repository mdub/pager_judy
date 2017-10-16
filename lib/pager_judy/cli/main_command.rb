require "clamp"
require "console_logger"
require "pager_judy/api/client"
require "pager_judy/cli/collection_behaviour"
require "pager_judy/cli/item_behaviour"
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

        include CollectionBehaviour

        private

        def collection
          client.services.with(:query => query)
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

      private

      def client
        signal_error "no --api-key provided" unless api_key
        HTTPI.logger = logger
        @client ||= PagerJudy::API::Client.new(api_key)
      end

      def logger
        @logger ||= ConsoleLogger.new(STDERR, debug?)
      end

    end

  end
end