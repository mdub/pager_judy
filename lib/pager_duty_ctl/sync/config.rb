require "config_hound"
require "config_mapper"
require "config_mapper/config_struct"

module PagerDutyCtl
  module Sync

    # load and validate our configuration
    class Config < ConfigMapper::ConfigStruct

      class << self

        # Load configuration.
        #
        # Multiple "sources" can be specified. First one wins.
        # Sources may be a file-name, a URI, or a raw Ruby Hash.
        #
        def from(config_sources)
          config_data = data_from(config_sources)
          config_data.delete("var")
          from_data(config_data)
        end

        # Load configuration data.
        #
        # Includes are processed; defaults are included, references are expanded.
        #
        def data_from(sources)
          ConfigHound.load(sources, :expand_refs => true, :include_key => "include")
        end

      end

      component_dict :escalation_policies do

        attribute :summary

      end

      component_dict :services do

        attribute :summary
        attribute :escalation_policy

      end

      def config_errors
        super.tap do |errors|
          escalation_policy_names = escalation_policies.keys
          services.each do |key, service|
            if service.escalation_policy
              unless escalation_policy_names.include?(service.escalation_policy)
                errors[".services[#{key}].escalation_policy"] = "Bad reference"
              end
            end
          end
        end
      end

    end

  end
end
