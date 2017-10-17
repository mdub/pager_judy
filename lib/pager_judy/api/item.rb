module PagerJudy
  module API

    class Item

      def initialize(resource, type, dry_run: false)
        @resource = resource
        @type = type
        @dry_run = dry_run
      end

      attr_reader :resource
      attr_reader :type
      attr_reader :dry_run

      def read
        resource.get.fetch(type)
      end

      def update(data)
        return data if dry_run
        resource.put(type => data).fetch(type)
      end

      def to_h
        read
      end

    end

  end
end
