require "pager_judy/api/collection"
require "pager_judy/api/resource"
require "uri"

module PagerJudy
  module API

    class Client

      def initialize(api_key, base_uri: "https://api.pagerduty.com/", logger: nil, dry_run: false)
        @api_key = api_key
        @base_uri = URI(base_uri)
        @logger = logger
        @dry_run = dry_run
      end

      attr_reader :api_key
      attr_reader :base_uri
      attr_reader :logger
      attr_reader :dry_run

      def root
        Resource.new(api_key: api_key, uri: base_uri, logger: logger)
      end

      def collection(type)
        Collection.new(root.subresource(type), type, dry_run: dry_run)
      end

      def escalation_policies
        collection("escalation_policies")
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

      def users
        collection("users")
      end

    end

  end
end
