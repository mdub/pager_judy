require "httpi"
require "multi_json"
require "uri"

module PagerDutyCtl
  module PagerDuty
    class Client

      def initialize(api_key, base_uri: "https://api.pagerduty.com/")
        @api_key = api_key
        @base_uri = URI(base_uri)
      end

      attr_reader :api_key
      attr_reader :base_uri

      def services
        MultiJson.load(resource("services").get).fetch("services")
      end

      def resource(path)
        Resource.new(api_key: api_key, uri: base_uri + path)
      end

      class Error < StandardError
      end

      class Resource

        def initialize(api_key:, uri:)
          @api_key = api_key
          @uri = uri
        end

        attr_reader :api_key
        attr_reader :uri

        def get
          request = new_request
          response = HTTPI.get(request)
          if response.error?
            raise Error, response.headers["Status"]
          end
          response.body
        end

        def new_request
          HTTPI::Request.new(uri.to_s).tap do |request|
            request.headers["Accept"] = "application/vnd.pagerduty+json;version=2"
            request.headers["Authorization"] = "Token token=#{api_key}"
          end
        end

      end

    end
  end
end
