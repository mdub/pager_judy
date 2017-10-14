require "clamp"
require "console_logger"
require "pager_duty_ctl/pager_duty/client"
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

        def execute
          puts YAML.dump(client.services)
        end

      end

      private

      def client
        signal_error "no --api-key provided" unless api_key
        HTTPI.logger = logger
        @client ||= PagerDutyCtl::PagerDuty::Client.new(api_key)
      end

      def logger
        @logger ||= ConsoleLogger.new(STDOUT, debug?)
      end

    end


  end
end
