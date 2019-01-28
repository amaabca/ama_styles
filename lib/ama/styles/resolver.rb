# frozen_string_literal: true

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
          LATEST_STYLESHEET_FILE
        ).to_s
      end
    end
  end
end
