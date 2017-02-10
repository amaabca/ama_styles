# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all
  # assets, yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.aws_access_key_id = ENV.fetch('AWS_ACCESS_KEY_ID')
  config.aws_secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  config.redis_endpoint = ENV.fetch('REDIS_ENDPOINT')
  config.api_deployment_url = ENV.fetch('API_DEPLOYMENT_URL')
  config.api_deployment_user = ENV.fetch('API_DEPLOYMENT_USER')
  config.api_deployment_password = ENV.fetch('API_DEPLOYMENT_PASSWORD')
  config.cloudfront_url = ENV.fetch('ASSET_CLOUDFRONT_URL')
  config.assets_bucket_name = ENV.fetch('S3_ASSETS_BUCKET_NAME')
end
