module PagerJudy
  module Sync

    class Syncer

      def initialize(client:, config:)
        @client = client
        @config = config
      end

      attr_reader :client
      attr_reader :config

      def sync
        config.services.each do |name, detail|
          client.services.create_or_update_by_name(name, detail.to_h)
        end
      end

    end

  end
end
