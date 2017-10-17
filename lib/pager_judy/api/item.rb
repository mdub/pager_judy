module PagerJudy
  module API

    class Item

      def initialize(resource, type, id, dry_run: false)
        @resource = resource
        @type = type
        @id = id
        @dry_run = dry_run
      end

      attr_reader :resource
      attr_reader :type
      attr_reader :id
      attr_reader :dry_run

      def read
        resource.get.fetch(type)
      end

      def update(data)
        result = dry_run ? data : resource.put(type => data).fetch(type)
        name = data.fetch("name")
        logger.info { "updated #{type} #{name.inspect} [#{id}]" }
      end

      def to_h
        read
      end

      private

      def logger
        resource.logger
      end

    end

  end
end
