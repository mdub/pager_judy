require "httpi"
require "multi_json"
require "pager_duty_ctl/api/errors"
require "uri"

module PagerDutyCtl
  module API

    class Resource

      def initialize(api_key:, uri:)
        @api_key = api_key
        @uri = URI(uri)
      end

      attr_reader :api_key
      attr_reader :uri

      def [](path)
        Resource.new(api_key: api_key, uri: uri + path)
      end

      def get(query = nil)
        request = new_request
        request.query = query if query
        response = HTTPI.get(request)
        if response.error?
          raise HttpError.new(request, response)
        end
        MultiJson.load(response.body)
      end

      private

      def new_request
        HTTPI::Request.new(uri.to_s).tap do |request|
          request.headers["Accept"] = "application/vnd.pagerduty+json;version=2"
          request.headers["Authorization"] = "Token token=#{api_key}"
        end
      end

    end

  end
end
