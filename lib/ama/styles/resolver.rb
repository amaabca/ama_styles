# frozen_string_literal: true

module AMA
  module Styles
    class Resolver
      include Globals
      attr_accessor :remote
      attr_writer :version

      def asset_path
        remote ? custom_asset_url : "#{version}/#{PRIMARY_STYLESHEET_NAME}"
      end

      def version
        @version ||= ama_styles_default_version
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
        Cache.read("#{CURRENT_STYLESHEET_DIGEST_KEY}/#{version}") || "#{version}/#{FALLBACK_STYLESHEET_FILE}"
      end
    end
  end
end
