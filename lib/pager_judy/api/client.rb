require "pager_judy/api/collection"
require "pager_judy/api/resource"
require "uri"

module PagerJudy
  module API

    # Communicate with the PagerDuty API.
    #
    class Client

      def initialize(api_key, base_uri: "https://api.pagerduty.com/", logger: nil, dry_run: false)
        @root = Resource.new(api_key: api_key, uri: URI(base_uri), logger: logger, dry_run: dry_run)
      end

      attr_reader :root

      def collection(type)
        Collection.new(root.subresource(type), type)
      end

      def escalation_policies
        collection("escalation_policies")
      end

      def incidents
        collection("incidents")
      end

      def notifications
        collection("notifications")
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

      def vendors
        collection("vendors")
      end

    end

  end
end
