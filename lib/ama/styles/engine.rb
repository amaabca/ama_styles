# frozen_string_literal: true

module AMA
  module Styles
    class Engine < ::Rails::Engine
      isolate_namespace AMA::Styles

      config.before_initialize do
        Rails.configuration.stylesheet_resolver = Resolver.new
        Rails.configuration.cloudfront_cache_store = Cache.build_store(
          :redis_store,
          db: 3,
          namespace: 'assets',
          host: Rails.configuration.redis_endpoint,
          raw: true
        )
      end
    end
  end
end
