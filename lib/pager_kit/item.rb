module PagerKit

  class Item

    def initialize(resource, type)
      @resource = resource
      @type = type
    end

    attr_reader :resource
    attr_reader :type

    def read
      resource.get.fetch(type)
    end

    def to_h
      read
    end

  end

end
