require "pager_judy/cli/data_display"

module PagerJudy
  module CLI

    # Common behaviour for sub-commands that operate on collections.
    #
    module CollectionBehaviour

      def self.included(target)
        target.default_subcommand = "summary"

        target.subcommand ["summary", "s"], "One-line summary" do
          include SummarySubcommand
        end

        target.subcommand ["data", "d"], "Full details" do
          include DataSubcommand
        end
      end

      module SummarySubcommand

        def execute
          collection.each do |item|
            puts "#{item.fetch('id')}: #{item.fetch('summary')}"
          end
        end

      end

      module DataSubcommand

        include DataDisplay

        def self.included(target)
          target.parameter "[EXPR]", "JMESPath expression"
        end

        def execute
          puts display_data(collection.to_a, expr)
        end

      end

    end

  end
end
