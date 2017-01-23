require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "font-awesome-sass"
require "foundation/rails"
require "aws-sdk"
require "rest-client"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AMA::Styles
  class Application < Rails::Application
    Aws.config.update(
      region: 'us-west-2',
      credentials: Aws::Credentials.new(
        ENV.fetch('AWS_ACCESS_KEY_ID'),
        ENV.fetch('AWS_SECRET_ACCESS_KEY')
      )
    )

    # We just need this configuartion variable to be readable
    config.cloudfront_url = nil
    config.active_record.raise_in_transactional_callbacks = true
    config.eager_load = false
  end
end
