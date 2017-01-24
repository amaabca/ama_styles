module AMA
  module Styles
    class Resolver
      include ActionView::Helpers::AssetTagHelper

      REVISION_KEY = 'styles/revision'.freeze
      attr_accessor :asset_host, :environment, :remote
      alias_method :remote?, :remote

      def initialize(opts = {})
        self.asset_host = opts.fetch(:asset_host) { Rails.configuration.cloudfront_url }
        self.environment = opts.fetch(:environment) { Rails.env }
        self.remote = opts.fetch(:remote) { environment == 'production' }
      end

      def resolve(name, opts = {})
        scope = opts.delete(:scope) { self }
        link = remote? ? custom_asset_url(name) : name
        scope.stylesheet_link_tag(link, opts)
      end

      def local?
        !remote?
      end

      private

      # There would need to be more configuration here likely (custom path, name, etc.)
      def custom_asset_url(name)
        URI.join(
          Rails.configuration.cloudfront_url,
          "assets/#{name}-#{current_revision}.css"
        ).to_s
      end

      def current_revision
        redis do |connection|
          connection.get(REVISION_KEY) || 'fallback'
        end
      end

      # Theoretically we'd be opening a new redis connection and closing
      # it on every request. There's likely a more optimal way to do this.
      def redis(&block)
        connection = Redis.new(
          host: Rails.configuration.redis_endpoint,
          db: 2
        )
        yield(connection).tap { connection.quit }
      end
    end
  end
end
