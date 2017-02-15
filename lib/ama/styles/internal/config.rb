# frozen_string_literal: true

Aws.config.update(
  region: 'us-west-2',
  credentials: Aws::Credentials.new(
    Rails.configuration.aws_access_key_id,
    Rails.configuration.aws_secret_access_key
  )
)

RestClient::Jogger::EventSubscriber.new.subscribe
