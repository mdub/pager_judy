require "config_mapper/config_struct"
require "pager_duty_ctl/config/mapping_error"

module PagerDutyCtl

  module Config

    class Model < ConfigMapper::ConfigStruct

      # Configure from data.
      #
      # Multiple hashes can be specified. Last one wins.
      #
      def self.from_data(config_data)
        new.tap do |model|
          errors = model.configure_with(config_data)
          raise MappingError, errors if errors.any?
        end
      end

      component :service do

      end

    end

  end

end
