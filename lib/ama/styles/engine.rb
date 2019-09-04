# frozen_string_literal: true

module AMA
  module Styles
    class Engine < ::Rails::Engine
      isolate_namespace AMA::Styles

      config.before_initialize do |app|
        app.config.stylesheet_resolver = Resolver.new
        app.config.cloudfront_cache_store = Cache.build_store(
          :redis_store,
          db: 3,
          namespace: 'assets',
          host: Rails.configuration.redis_endpoint,
          raw: true
        )
      end

      config.after_initialize do |app|
        # are we using bundled assets? (i.e. dev/local)
        if app.config.stylesheet_resolver.local? && Rails.env.development?
          # is a source location provided for the font awesome pro font files?
          if app.config.font_awesome_pro_source_path.present?
            # are there already pro files in the application asset folder?
            unless app.root.join('vendor', 'assets', 'fonts', 'font-awesome').exist?
              Rake::Task['assets:fa5_pro'].invoke(
                app.config.font_awesome_pro_source_path,
                app.root.to_s
              )
            end
          end
        end
      end
    end
  end
end
