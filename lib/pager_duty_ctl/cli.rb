require "clamp"
require "console_logger"
require "pager_duty_ctl/version"

module PagerDutyCtl
  module CLI

    class MainCommand < Clamp::Command

      option "--debug", :flag, "enable debugging", :attribute_name => :debug

      option "--version", :flag, "display version" do
        puts PagerDutyCtl::VERSION
        exit 0
      end

      def execute
        logger.info "NADA"
      end

      private

      def logger
        @logger ||= ConsoleLogger.new(STDOUT, debug?)
      end

    end

  end

end
