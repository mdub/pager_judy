module PagerJudy
  module API

    # Represents an item, e.g. a service, a user, ...
    #
    class Item

      def initialize(resource, type, id)
        @resource = resource
        @type = type
        @id = id
      end

      attr_reader :resource
      attr_reader :type
      attr_reader :id
      attr_reader :dry_run

      def read
        resource.get.fetch(type)
      end

      def update(data)
        if dry_run?
          result = data
        else
          result = resource.put(type => data).fetch(type)
        end
        name = result.fetch("name")
        logger.info { "updated #{type} #{name.inspect} [#{id}]" }
      end

      def to_h
        read
      end

      private

      def logger
        resource.logger
      end

      def dry_run?
        resource.dry_run?
      end

    end

  end
end
