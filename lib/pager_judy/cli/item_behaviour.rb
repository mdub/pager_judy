require "pager_judy/cli/data_display"

module PagerJudy
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
