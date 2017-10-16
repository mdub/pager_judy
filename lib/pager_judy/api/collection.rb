require "pager_judy/api/item"

module PagerJudy
  module API

    class Collection

      def initialize(resource, type, options = {})
        @resource = resource
        @type = type
        @options = options
      end

      attr_reader :resource
      attr_reader :type
      attr_reader :options

      def item_type
        type.chomp("s")
      end

      include Enumerable

      def with(more_options)
        more_options = Hash[more_options.select { |_,v| v }]
        Collection.new(resource, type, options.merge(more_options))
      end

      def each
        offset = 0
        loop do
          data = resource.get(options.merge(offset: offset, limit: 100))
          data.fetch(type).each do |item|
            yield item
          end
          break unless data["more"]
          offset = data.fetch("offset") + data.fetch("limit")
        end
        self
      end

      def [](id)
        Item.new(resource.subresource(id), item_type)
      end

      def create(data)
        resource.post(item_type => data).fetch(item_type)
      end

    end

  end
end
