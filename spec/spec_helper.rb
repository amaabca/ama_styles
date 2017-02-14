# frozen_string_literal: true
require 'simplecov'
ENV['RAILS_ENV'] = 'test'
require 'ama/styles/cli_base'
require File.expand_path('../../spec/dummy/config/environment.rb', __FILE__)
require 'ama/styles/deployment'
require 'webmock/rspec'
require 'factory_girl'
require 'pry'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Helpers::Fixtures
  config.include Helpers::Requests

  config.before(:suite) do
    FactoryGirl.find_definitions
  end

  config.full_backtrace = true
end
