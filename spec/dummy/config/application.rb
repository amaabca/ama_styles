require_relative 'boot'

require 'rails/all'
require 'active_support/core_ext/integer/time.rb'

Bundler.require(*Rails.groups)
require 'ama_styles'

module Dummy
  class Application < Rails::Application
  end
end
