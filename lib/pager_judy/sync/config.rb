require "config_hound"
require "config_mapper"
require "config_mapper/config_struct"

module PagerJudy
  module Sync

    # load and validate our configuration
    class Config < ConfigMapper::ConfigStruct

      class << self

        # Load configuration.
        #
        # Multiple "sources" can be specified. First one wins.
        # Sources may be a file-name, a URI, or a raw Ruby Hash.
        #
        def from(*config_sources)
          config_data = data_from(*config_sources)
          config_data.delete("var")
          from_data(config_data)
        end

        # Load configuration data.
        #
        # Includes are processed; defaults are included, references are expanded.
        #
        def data_from(*sources)
          ConfigHound.load(sources, expand_refs: true, include_key: "include")
        end

      end

      component_dict :escalation_policies do

        attribute :description

      end

      component_dict :services do

        attribute :description

        attribute :acknowledgement_timeout, default: 1800

        attribute :auto_resolve_timeout, default: 14400

        component :escalation_policy do

          attribute :id

          def to_h
            super.merge("type" => "escalation_policy_reference")
          end

        end

      end

    end

  end
end
