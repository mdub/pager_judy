require "pager_judy/api/item"

module PagerJudy
  module API

    class Collection

      def initialize(resource, type, criteria = {}, dry_run: false)
        @resource = resource
        @type = type
        @criteria = criteria
        @dry_run = dry_run
      end

      attr_reader :resource
      attr_reader :type
      attr_reader :criteria
      attr_reader :dry_run

      def item_type
        type.sub(/ies$/, "y").chomp("s")
      end

      include Enumerable

      def with(more_criteria)
        more_criteria = Hash[more_criteria.select { |_,v| v }]
        Collection.new(resource, type, criteria.merge(more_criteria))
      end

      def each
        offset = 0
        loop do
          data = resource.get(criteria.merge(offset: offset, limit: 100))
          data.fetch(type).each do |item|
            yield item
          end
          break unless data["more"]
          offset = data.fetch("offset") + data.fetch("limit")
        end
        self
      end

      def [](id)
        Item.new(resource.subresource(id), item_type, dry_run: dry_run)
      end

      def create(data)
        if dry_run
          fake_id = "{{" + data.fetch("name") + "}}"
          return data.merge("id" => fake_id)
        end
        resource.post(item_type => data).fetch(item_type)
      end

      def create_or_update(id, data)
        if id.nil?
          create(data)
        else
          self[id].update(data)
        end
      end

      def id_for_name(name)
        ids_by_name[name]
      end

      def create_or_update_by_name(name, data)
        create_or_update(id_for_name(name), data.merge("name" => name))
      end

      private

      def ids_by_name
        @ids_by_name ||= each_with_object({}) do |item, result|
          result[item.fetch("name")] = item.fetch("id")
        end
      end

    end

  end
end
