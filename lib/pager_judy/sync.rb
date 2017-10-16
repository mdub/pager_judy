require "pager_judy/sync/config"
require "pager_judy/sync/syncer"

module PagerJudy
  module Sync

    def self.sync(*args)
      Syncer.new(*args).sync
    end

  end
end
