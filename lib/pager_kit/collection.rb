module PagerKit

  class Collection

    def initialize(resource, key, options = {})
      @resource = resource
      @key = key
      @options = options
    end

    attr_reader :resource
    attr_reader :key
    attr_reader :options

    include Enumerable

    def with(more_options)
      more_options = Hash[more_options.select { |_,v| v }]
      Collection.new(resource, key, options.merge(more_options))
    end

    def each
      offset = 0
      loop do
        data = resource.get(options.merge(offset: offset, limit: 100))
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
