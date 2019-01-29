# frozen_string_literal: true

require 'simplecov'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../spec/dummy/config/environment.rb', __dir__)
require 'ama/styles/internal/base'
require 'webmock/rspec'
require 'factory_bot'
require 'pry'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Helpers::Fixtures
  config.include Helpers::Requests

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.full_backtrace = true
end
