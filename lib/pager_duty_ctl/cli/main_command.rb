require "clamp"
require "console_logger"
require "pager_duty_ctl/api/client"
require "pager_duty_ctl/cli/collection_behaviour"
require "pager_duty_ctl/version"

module PagerDutyCtl
  module CLI

    class MainCommand < Clamp::Command

      option "--debug", :flag, "enable debugging", :attribute_name => :debug

      option "--version", :flag, "display version" do
        puts PagerDutyCtl::VERSION
        exit 0
      end

      option "--api-key", "KEY", "PagerDuty API key",
             :environment_variable => "PAGER_DUTY_API_KEY"

      subcommand "schedules", "Display schedules" do

        option %w[-q --query], "FILTER", "name filter"

        include CollectionBehaviour

        private

        def collection
          client.schedules.with(:query => query)
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
        @client ||= PagerDutyCtl::API::Client.new(api_key)
      end

      def logger
        @logger ||= ConsoleLogger.new(STDERR, debug?)
      end

    end

  end
end
