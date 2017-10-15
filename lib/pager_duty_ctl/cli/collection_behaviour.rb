require "yaml"

module PagerDutyCtl
  module CLI

    module CollectionBehaviour

      def self.included(target)

        target.default_subcommand = "summary"

        target.subcommand ["summary", "s"], "One-line summary" do

          def execute
            collection.each do |item|
              puts "#{item.fetch("id")}: #{item.fetch("name")}"
            end
          end

        end

        target.subcommand ["data", "d"], "Full details" do

          def execute
            puts YAML.dump(collection.to_a)
          end

        end

      end

    end

  end
end
