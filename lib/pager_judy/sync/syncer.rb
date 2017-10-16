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
          payload = detail.to_h.merge(name: name)
          client.services.create(payload)
        end
      end

    end

  end
end
