# frozen_string_literal: true

module AMA
  module Styles
    class Resolver
      include Globals
      attr_accessor :remote
      attr_writer :version

      def asset_path(asset_version = version)
        remote ? custom_asset_url(asset_version) : "#{asset_version}/#{PRIMARY_STYLESHEET_NAME}"
      end

      def version
        @version || cached_ama_styles_version
      end

      private

      def cached_ama_styles_version
        cached_version = Cache.read(AMA_STYLES_VERSION_KEY)
        return ama_styles_default_version if ama_styles_versions.exclude?(cached_version)

        cached_version
      end

      def custom_asset_url(asset_version = version)
        URI.join(
          Rails.configuration.cloudfront_url,
          ASSET_PREFIX,
          current_revision(asset_version)
        ).to_s
      end

      def current_revision(asset_version = version)
        Cache.read("#{CURRENT_STYLESHEET_DIGEST_KEY}/#{asset_version}") || "#{asset_version}/#{FALLBACK_STYLESHEET_FILE}"
      end
    end
  end
end
