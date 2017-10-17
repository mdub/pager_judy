require "httpi"
require "multi_json"
require "pager_judy/api/errors"
require "uri"

module PagerJudy
  module API

    class Resource

      def initialize(api_key:, uri:, logger: nil)
        @api_key = api_key
        @uri = URI(uri.to_s.chomp("/"))
        @type = @uri.to_s.split("/").last
        @logger = logger || Logger.new(nil)
      end

      attr_reader :api_key
      attr_reader :uri
      attr_reader :type
      attr_reader :logger

      def subresource(path)
        Resource.new(api_key: api_key, uri: "#{uri}/#{path}", logger: logger)
      end

      def get(query = nil)
        request = new_request
        request.query = query if query
        debug("GET", request.url)
        response = HTTPI.get(request)
        if response.error?
          raise HttpError.new(request, response)
        end
        MultiJson.load(response.body)
      end

      def post(data)
        request = new_request
        request.body = MultiJson.dump(data)
        debug("POST", request.url, data)
        response = HTTPI.post(request)
        if response.error?
          raise HttpError.new(request, response)
        end
        MultiJson.load(response.body)
      end

      def put(data)
        request = new_request
        request.body = MultiJson.dump(data)
        debug("PUT", request.url, data)
        response = HTTPI.put(request)
        if response.error?
          raise HttpError.new(request, response)
        end
        MultiJson.load(response.body)
      end

      private

      def debug(operation, url, data = nil)
        logger.debug do
          data_dump = MultiJson.dump(data, pretty: true) if data
          [operation, url, data_dump].join(" ")
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
