require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "ama_styles"

module Dummy
  class Application < Rails::Application
  end
end
