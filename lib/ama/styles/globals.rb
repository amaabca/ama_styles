# frozen_string_literal: true

module AMA
  module Styles
    module Globals
      GEM_ROOT_PATH = Gem.loaded_specs['ama_styles'].full_gem_path.freeze
      ASSET_PATH = File.join(GEM_ROOT_PATH, 'app', 'assets').freeze
      CURRENT_STYLESHEET_DIGEST_KEY = 'current_stylesheet_digest'
      CURRENT_MANIFEST_KEY = 'current_manifest'
      CURRENT_DEPLOYMENT_DATE_KEY = 'deployed_on'
      PRIMARY_STYLESHEET_NAME = 'shared'
      PRIMARY_STYLESHEET_FILE = "#{PRIMARY_STYLESHEET_NAME}.css"
      FALLBACK_STYLESHEET_NAME = 'fallback'
      FALLBACK_STYLESHEET_FILE = "#{FALLBACK_STYLESHEET_NAME}.css"
      LATEST_STYLESHEET_NAME = 'latest'
      LATEST_STYLESHEET_FILE = "#{LATEST_STYLESHEET_NAME}.css"
      ASSET_PREFIX = 'assets/'
      FAR_FUTURE_CACHE_EXPIRATION = 30.years.freeze

      def root_path
        Rails.root
      end
    end
  end
end
