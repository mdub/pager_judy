require "httpi"
require "multi_json"
require "pager_judy/api/errors"
require "uri"

module PagerJudy
  module API

    class Resource

      def initialize(api_key:, uri:, logger: nil, dry_run: false)
        @api_key = api_key
        @uri = URI(uri.to_s.chomp("/"))
        @type = @uri.to_s.split("/").last
        @logger = logger || Logger.new(nil)
        @dry_run = dry_run
      end

      attr_reader :api_key
      attr_reader :uri
      attr_reader :type
      attr_reader :logger

      def dry_run?
        @dry_run
      end

      def subresource(path)
        Resource.new(api_key: api_key, uri: "#{uri}/#{path}", logger: logger, dry_run: dry_run?)
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
