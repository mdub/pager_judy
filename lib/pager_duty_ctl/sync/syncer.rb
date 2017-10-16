module PagerDutyCtl
  module Sync

    class Syncer

      def initialize(client:, config:)
        @client = client
        @config = config
      end

      attr_reader :client
      attr_reader :config

      def sync
        # client.services["S123"].update(:name => "foo")
      end

    end

  end
end
