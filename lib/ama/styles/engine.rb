module AMA
  module Styles
    ASSET_PATH = File.join(
      Gem.loaded_specs['ama_styles'].full_gem_path,
      'app',
      'assets'
    ).freeze

    class Engine < ::Rails::Engine
      isolate_namespace AMA::Styles

      config.before_initialize do
        Rails.configuration.stylesheet_resolver = AMA::Styles::Resolver.new
      end
    end
  end
end
