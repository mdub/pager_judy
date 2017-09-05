require "clamp"
require "json"
require "console_logger"
require "pager_duty_ctl/config"
require "pager_duty_ctl/version"
require "pager_duty_ctl/api/service"

module PagerDutyCtl

  module CLI
    class MainCommand < Clamp::Command

      option "--debug", :flag, "enable debugging", :attribute_name => :debug

      option "--version", :flag, "display version" do
        puts PagerDutyCtl::VERSION
        exit 0
      end

      option ["-c", "--config-file"], "CONFIG_FILE", "configuration file", default: "./pager-config.yml"

      subcommand ["upsert", "deploy"], "Create/update pager config" do

        def execute
          service = PagerDutyCtl::PagerDutyApi::Service.new.create_or_update(config.service.to_h)
          puts service
        end

      end

      subcommand ["drop", "delete"], "Destroy pager config" do

        def execute
          puts "Bye!!"
        end

      end

      subcommand ["diff"], "Show pending pager config diffs" do

        option "--diff-format", "FORMAT", "'text', 'color', or 'html'", :default => "color"

        def execute
          puts "Nothing to see here....yet"
        end

      end

      subcommand "dump", "Display configuration details" do

        subcommand "config", "Print combined configuration" do

          def execute
            puts "Nothing to see here....yet"
          end

        end

      end

      def run(*args)
        super(*args)
        # handle exceptions here
      end

      private

      def logger
        @logger ||= ConsoleLogger.new(STDOUT, debug?)
      end

      def config
        @config ||=
          PagerDutyCtl::Config.from_files([File.expand_path(config_file)])
      end

    end

  end

end
