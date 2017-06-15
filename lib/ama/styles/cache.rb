# frozen_string_literal: true

module AMA
  module Styles
    class Cache
      DELEGATIONS = %i[fetch read write delete clear].freeze

      class << self
        delegate(*DELEGATIONS, to: :store)

        def store
          Rails.configuration.cloudfront_cache_store
        end

        def build_store(cache_store, opts = {})
          ActiveSupport::Cache.lookup_store(cache_store, opts)
        end

        def transaction
          store.data.multi do
            yield self
          end
        end
      end
    end
  end
end
