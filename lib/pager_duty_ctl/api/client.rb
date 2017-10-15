require "pager_duty_ctl/api/resource"
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

      def root
        Resource.new(api_key: api_key, uri: base_uri)
      end

      def services
        root["/services"].get.fetch("services")
      end

    end

  end
end
