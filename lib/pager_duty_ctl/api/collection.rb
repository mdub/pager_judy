module PagerDutyCtl
  module API

    class Collection

      def initialize(resource, key)
        @resource = resource
        @key = key
      end

      attr_reader :resource
      attr_reader :key

      include Enumerable

      def each
        offset = 0
        loop do
          data = resource.get(offset: offset, limit: 100)
          data.fetch(key).each do |item|
            yield item
          end
          break unless data["more"]
          offset = data.fetch("offset") + data.fetch("limit")
        end
        self
      end

    end

  end
end
