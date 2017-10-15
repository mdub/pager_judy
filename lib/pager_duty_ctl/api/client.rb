require "httpi"
require "multi_json"
require "uri"

module PagerDutyCtl
  module API
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

      class HttpError < StandardError

        def initialize(request, response)
          @request = request
          @response = response
          super("#{request.url} - #{response.headers.fetch("Status")}")
        end

        attr_reader :request
        attr_reader :response

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
            raise HttpError.new(request, response)
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
