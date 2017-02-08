module AMA
  module Styles
    class Resolver
      attr_accessor :remote

      def asset_path
        if remote
          custom_asset_url
        else
          'application'
        end
      end

    private

      def custom_asset_url
        URI.join(
          Rails.configuration.cloudfront_url,
          '/assets/',
          current_revision
        ).to_s
      end

      def current_revision
        Cache.fetch(Globals::CURRENT_STYLESHEET_DIGEST_KEY) || 'fallback.css'
      end
    end
  end
end
