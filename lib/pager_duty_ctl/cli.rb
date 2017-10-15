require "clamp"
require "console_logger"
require "pager_duty_ctl/api/client"
require "pager_duty_ctl/version"
require "yaml"

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

      subcommand "services", "Display services" do

        self.default_subcommand = "summary"

        option %w[-q --query], "FILTER", "name filter"

        subcommand "summary", "Show summary" do
          def execute
            collection.each do |item|
              puts "#{item.fetch("id")}: #{item.fetch("name")}"
            end
          end
        end

        subcommand "data", "Show full data" do
          def execute
            puts YAML.dump(collection.to_a)
          end
        end

        private

        def collection
          client.services.with(:query => query)
        end

      end

      subcommand "teams", "Display teams" do

        self.default_subcommand = "summary"

        option %w[-q --query], "FILTER", "name filter"

        subcommand "summary", "Show summary" do
          def execute
            collection.each do |item|
              puts "#{item.fetch("id")}: #{item.fetch("name")}"
            end
          end
        end

        subcommand "data", "Show full data" do
          def execute
            puts YAML.dump(collection.to_a)
          end
        end

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
