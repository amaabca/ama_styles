# frozen_string_literal: true
Rails.application.configure do
  config.eager_load = false
  config.assets.css_compressor = :sass
  config.assets.precompile += %w(shared.css)
  config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.redis_endpoint = ENV['REDIS_ENDPOINT']
  config.api_deployment_url = ENV['API_DEPLOYMENT_URL']
  config.api_deployment_user = ENV['API_DEPLOYMENT_USER']
  config.api_deployment_password = ENV['API_DEPLOYMENT_PASSWORD']
  config.cloudfront_url = ENV['ASSET_CLOUDFRONT_URL']
  config.assets_bucket_name = ENV['S3_ASSETS_BUCKET_NAME']
end
