module AMA
  module Styles
    class Cache
      class << self
        attr_reader :store

        delegate :fetch, :read, :write, :delete, :clear, to: :store

        def store
          Rails.configuration.cloudfront_cache_store
        end

        def build_store(cache_store, opts = {})
          ActiveSupport::Cache.lookup_store(cache_store, opts)
        end
      end
    end
  end
end
