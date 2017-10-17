require "pager_judy/cli/data_display"

module PagerJudy
  module CLI

    module CollectionBehaviour

      def self.included(target)
        target.default_subcommand = "summary"

        target.subcommand ["summary", "s"], "One-line summary" do

          def execute
            collection.each do |item|
              puts "#{item.fetch('id')}: #{item.fetch('name')}"
            end
          end

        end

        target.subcommand ["data", "d"], "Full details" do

          include DataDisplay

          parameter "[EXPR]", "JMESPath expression"

          def execute
            puts display_data(collection.to_a, expr)
          end

        end
      end

    end

  end
end
