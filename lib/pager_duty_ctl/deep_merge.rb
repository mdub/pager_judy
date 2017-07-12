require "config_hound"

module PagerDutyCtl

  module DeepMerge

      # Deep-merge config data hashes.
      #
      # Hashes later in the list take precedence.
      #
      def deep_merge(*hashes)
        hashes.inject({}) do |result, overrides|
          ConfigHound.deep_merge_into(result, overrides)
        end
      end

  end

end
