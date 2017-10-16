require "clamp"
require "jmespath"
require "multi_json"
require "yaml"

module PagerJudy
  module CLI

    module DataDisplay

      extend Clamp::Option::Declaration

      option %w[-f --format], "FORMAT", "format for data output",
             :attribute_name => :output_format,
             :default => "YAML"

      def output_format=(arg)
        arg = arg.upcase
        unless %w(JSON YAML).member?(arg)
          raise ArgumentError, "unrecognised data format: #{arg.inspect}"
        end
        @output_format = arg
      end

      protected

      def format_data(data)
        case output_format
        when "JSON"
          MultiJson.dump(data, :pretty => true)
        when "YAML"
          YAML.dump(data)
        else
          raise "bad output format: #{output_format}"
        end
      end

      def select_data(data, jmespath_expression = nil)
        return data if jmespath_expression.nil?
        JMESPath.search(jmespath_expression, data)
      rescue JMESPath::Errors::SyntaxError => e
        signal_error("invalid JMESPath expression")
      end

      def display_data(data, jmespath_expression = nil)
        format_data(select_data(data, jmespath_expression))
      end

    end

  end
end
