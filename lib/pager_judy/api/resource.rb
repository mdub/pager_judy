require "httpi"
require "multi_json"
require "pager_judy/api/errors"
require "uri"

module PagerJudy
  module API

    class Resource

      def initialize(api_key:, uri:, logger:)
        @api_key = api_key
        @uri = URI(uri.to_s.chomp("/"))
        @type = @uri.to_s.split("/").last
        @logger = logger
      end

      attr_reader :api_key
      attr_reader :uri
      attr_reader :type
      attr_reader :logger

      def subresource(path)
        Resource.new(api_key: api_key, uri: "#{uri}/#{path}", logger: logger)
      end

      def get(query = nil)
        debug("GET")
        request = new_request
        request.query = query if query
        response = HTTPI.get(request)
        if response.error?
          raise HttpError.new(request, response)
        end
        MultiJson.load(response.body)
      end

      def post(data)
        debug("POST", data)
        request = new_request
        request.body = MultiJson.dump(data)
        response = HTTPI.post(request)
        if response.error?
          raise HttpError.new(request, response)
        end
        MultiJson.load(response.body)
      end

      def put(data)
        debug("PUT", data)
        request = new_request
        request.body = MultiJson.dump(data)
        response = HTTPI.put(request)
        if response.error?
          raise HttpError.new(request, response)
        end
        MultiJson.load(response.body)
      end

      private

      def debug(operation, data = nil)
        logger.debug do
          data_dump = MultiJson.dump(data, pretty: true) if data
          [operation, uri, data_dump].join(" ")
        end
      end

      def new_request
        HTTPI::Request.new(uri.to_s).tap do |req|
          req.headers["Accept"] = "application/vnd.pagerduty+json;version=2"
          req.headers["Authorization"] = "Token token=#{api_key}"
          req.headers["Content-Type"] = "application/json"
        end
      end

    end

  end
end
