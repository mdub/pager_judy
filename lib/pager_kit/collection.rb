require "pager_kit/item"

module PagerKit

  class Collection

    def initialize(resource, type, options = {})
      @resource = resource
      @type = type
      @options = options
    end

    attr_reader :resource
    attr_reader :type
    attr_reader :options

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
      Item.new(resource.subresource(id), type.chomp("s"))
    end

  end

end
