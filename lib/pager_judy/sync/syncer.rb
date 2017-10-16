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
        service_ids_by_name = make_identity_map(client.services)
        config.services.each do |name, detail|
          payload = detail.to_h.merge(name: name)
          id = service_ids_by_name[name]
          if id.nil?
            client.services.create(payload)
          else
            client.services[id].update(payload)
          end
        end
      end

      def make_identity_map(collection)
        collection.each_with_object({}) do |item, result|
          result[item.fetch("name")] = item.fetch("id")
        end
      end

    end

  end
end
