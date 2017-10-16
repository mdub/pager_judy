module PagerDutyCtl
  module Sync

    class Syncer

      def initialize(client:, config:)
        @client = client
        @config = config
      end

      def sync
      end

    end

  end
end
