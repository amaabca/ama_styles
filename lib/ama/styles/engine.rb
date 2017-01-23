module AMA
  module Styles
    class Engine < ::Rails::Engine
      isolate_namespace AMA::Styles

      config.before_initialize do
        Rails.configuration.stylesheet_resolver = AMA::Styles::Resolver.new
      end
    end
  end
end
