require "config_hound"
require "config_mapper"
require "pager_duty_ctl/deep_merge"
require "pager_duty_ctl/config/model"

module PagerDutyCtl

  module Config

    class << self

      include PagerDutyCtl::DeepMerge

      # Configure from data.
      #
      # Multiple hashes can be specified. Last one wins.
      #
      def from_data(*config_hashes)
        Config::Model.from_data(deep_merge(*config_hashes))
      end

      # Configure from files.
      #
      # Multiple files can be specified. Last one wins.
      #
      def from_files(config_files, overrides = [])
        from_data(load_files(config_files, overrides))
      end

      # Load configuration data from files.
      #
      def data_from_files(config_files, overrides = [])
        load_files(config_files, overrides)
      end

      # Return defaults, as data.
      #
      def defaults
        load_file(defaults_file)
      end

      private

      def defaults_file
        File.expand_path("../../../defaults.yml", __FILE__)
      end

      def load_file(file_name)
        ConfigHound.load(file_name, include_key: "include")
      end

      def load_files(config_files, overrides = [])
        hashes = [defaults]
        hashes += config_files.map(&method(:load_file))
        hashes += overrides.map(&method(:parse_override))
        deep_merge(*hashes)
      end

      def parse_override(override)
        key, val = override.split("=", 2)
        key.split(".").reverse.reduce(val) { |a, e| { e => a } }
      end

    end

  end

end
