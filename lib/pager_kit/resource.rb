require "httpi"
require "multi_json"
require "pager_kit/errors"
require "uri"

module PagerKit

  class Resource

    def initialize(api_key:, uri:)
      @api_key = api_key
      @uri = URI(uri.to_s.chomp("/"))
      @type = @uri.to_s.split("/").last
    end

    attr_reader :api_key
    attr_reader :uri
    attr_reader :type

    def subresource(path)
      Resource.new(api_key: api_key, uri: "#{uri}/#{path}")
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

    def post(data)
      request = new_request
      request.body = MultiJson.dump(data)
      response = HTTPI.post(request)
      if response.error?
        raise HttpError.new(request, response)
      end
      MultiJson.load(response.body)
    end

    private

    def new_request
      HTTPI::Request.new(uri.to_s).tap do |req|
        req.headers["Accept"] = "application/vnd.pagerduty+json;version=2"
        req.headers["Authorization"] = "Token token=#{api_key}"
        req.headers["Content-Type"] = "application/json"
      end
    end

  end

end
