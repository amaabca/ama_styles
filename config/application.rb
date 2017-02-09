require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'sprockets/railtie'
require 'font-awesome-sass'
require 'foundation/rails'
require 'aws-sdk'
require 'rest-client'
require 'dotenv/rails-now'
require 'colorize'

Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module AMA::Styles
  class Application < Rails::Application
    Aws.config.update(
      region: 'us-west-2',
      credentials: Aws::Credentials.new(
        ENV.fetch('AWS_ACCESS_KEY_ID'),
        ENV.fetch('AWS_SECRET_ACCESS_KEY')
      )
    )
    config.cloudfront_url = ENV.fetch('ASSET_CLOUDFRONT_URL')
    config.api_deployment_url = ENV.fetch('API_DEPLOYMENT_URL')
    config.assets_bucket_name = ENV.fetch('S3_ASSETS_BUCKET_NAME')
    config.redis_endpoint = ENV.fetch('REDIS_ENDPOINT')
  end
end
