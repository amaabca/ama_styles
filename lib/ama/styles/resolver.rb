module AMA
  module Styles
    class Resolver
      include Globals
      attr_accessor :remote

      def asset_path
        remote ? custom_asset_url : PRIMARY_STYLESHEET_NAME
      end

    private

      def custom_asset_url
        URI.join(
          Rails.configuration.cloudfront_url,
          ASSET_PREFIX,
          current_revision
        ).to_s
      end

      def current_revision
        Cache.read(CURRENT_STYLESHEET_DIGEST_KEY) || FALLBACK_STYLESHEET_FILE
      end
    end
  end
end
