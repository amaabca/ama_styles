module AMA
  module Styles
    module Globals
      ROOT_PATH = Gem.loaded_specs['ama_styles'].full_gem_path
      ASSET_PATH = File.join(ROOT_PATH, 'app', 'assets').freeze
      CURRENT_STYLESHEET_DIGEST_KEY = 'current_stylesheet_digest'.freeze
      CURRENT_MANIFEST_KEY = 'current_manifest'.freeze
      DEPLOYMENT_DATE_KEY = 'deployed_on'.freeze
      ASSET_PREFIX = 'assets/'.freeze
    end
  end
end
