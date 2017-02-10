# frozen_string_literal: true

require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'sprockets/railtie'
require 'ama_styles'
Dotenv::Railtie.load

module AMA
  module Styles
    class Application < Rails::Application
    end
  end
end
