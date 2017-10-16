require "pager_kit/collection"
require "pager_kit/resource"
require "uri"

module PagerKit

  class Client

    def initialize(api_key, base_uri: "https://api.pagerduty.com/")
      @api_key = api_key
      @base_uri = URI(base_uri)
    end

    attr_reader :api_key
    attr_reader :base_uri

    def root
      Resource.new(api_key: api_key, uri: base_uri)
    end

    def collection(type)
      Collection.new(root.subresource(type), type)
    end

    def schedules
      collection("schedules")
    end

    def services
      collection("services")
    end

    def teams
      collection("teams")
    end

  end

end
