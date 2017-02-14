# frozen_string_literal: true

Rails.application.configure do
  config.eager_load = false
  config.assets.css_compressor = :sass
  config.assets.precompile += %w(shared.css)
  config.aws_access_key_id = ENV.fetch('AWS_ACCESS_KEY_ID')
  config.aws_secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  config.redis_endpoint = ENV.fetch('REDIS_ENDPOINT')
  config.api_deployment_url = ENV.fetch('API_DEPLOYMENT_URL')
  config.api_deployment_user = ENV.fetch('API_DEPLOYMENT_USER')
  config.api_deployment_password = ENV.fetch('API_DEPLOYMENT_PASSWORD')
  config.cloudfront_url = ENV.fetch('ASSET_CLOUDFRONT_URL')
  config.assets_bucket_name = ENV.fetch('S3_ASSETS_BUCKET_NAME')
end

Aws.config.update(
  region: 'us-west-2',
  credentials: Aws::Credentials.new(
    Rails.configuration.aws_access_key_id,
    Rails.configuration.aws_secret_access_key
  )
)

RestClient::Jogger::EventSubscriber.new.subscribe
