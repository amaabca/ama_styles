# frozen_string_literal: true

module AMA
  module Styles
    module Internal
      class Environment
        include Globals

        attr_accessor :environment

        def initialize(opts = {})
          self.environment = opts.fetch(:environment)
        end

        def load!
          overload
          configure
          configure_aws
        end

        private

        def normalized_environment
          environment == 'staging' ? 'production' : environment
        end

        def overload
          Dotenv.overload(".env.#{environment}")
          Rails.env = normalized_environment
        end

        def configure
          configure_redis
          configure_assets
          configure_api
          configure_aws
          configure_aws_client
        end

        def configure_redis
          config.redis_endpoint = ENV['REDIS_ENDPOINT']
        end

        def configure_aws
          config.aws_access_key_id = ENV['AWS_STYLES_USER_ACCESS_KEY_ID']
          config.aws_secret_access_key = ENV['AWS_STYLES_USER_SECRET_ACCESS_KEY']
          config.cloudfront_url = ENV['ASSET_CLOUDFRONT_URL']
          config.assets_bucket_name = ENV['S3_ASSETS_BUCKET_NAME']
        end

        def configure_aws_client
          Aws.config.update(
            region: 'us-west-2',
            credentials: Aws::Credentials.new(
              config.aws_access_key_id,
              config.aws_secret_access_key
            )
          )
        end

        def configure_assets
          config.eager_load = false
          config.assets.css_compressor = :sass
          ama_styles_versions.each do |version|
            config.assets.precompile += %W[#{version}/shared.css]
          end
        end

        def configure_api
          config.api_deployment_url = ENV['API_DEPLOYMENT_URL']
          config.api_deployment_user = ENV['API_DEPLOYMENT_USER']
          config.api_deployment_password = ENV['API_DEPLOYMENT_PASSWORD']
        end

        def config
          Rails.configuration
        end
      end
    end
  end
end
