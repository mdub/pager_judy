require "pager_duty_ctl/cli/data_display"

module PagerDutyCtl
  module CLI

    module ItemBehaviour

      def self.included(target)

        target.default_subcommand = "data"

        target.subcommand ["data", "d"], "Full details" do

          include DataDisplay

          def execute
            puts display_data(item.to_h)
          end

        end

      end

    end

  end
end
