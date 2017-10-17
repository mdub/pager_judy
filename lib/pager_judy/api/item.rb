module PagerJudy
  module API

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
        result = if dry_run?
                   data
                 else
                   resource.put(type => data).fetch(type)
        end
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

      def dry_run?
        resource.dry_run?
      end

    end

  end
end
