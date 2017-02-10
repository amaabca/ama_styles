# frozen_string_literal: true

module AMA
  module Styles
    module Globals
      ROOT_PATH = Gem.loaded_specs['ama_styles'].full_gem_path.freeze
      ASSET_PATH = File.join(ROOT_PATH, 'app', 'assets').freeze
      CURRENT_STYLESHEET_DIGEST_KEY = 'current_stylesheet_digest'
      CURRENT_MANIFEST_KEY = 'current_manifest'
      CURRENT_DEPLOYMENT_DATE_KEY = 'deployed_on'
      PRIMARY_STYLESHEET_NAME = 'shared'
      PRIMARY_STYLESHEET_FILE = "#{PRIMARY_STYLESHEET_NAME}.css"
      FALLBACK_STYLESHEET_NAME = 'fallback'
      FALLBACK_STYLESHEET_FILE = "#{FALLBACK_STYLESHEET_NAME}.css"
      ASSET_PREFIX = 'assets/'
    end
  end
end
