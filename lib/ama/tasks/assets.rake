# frozen_string_literal: true

namespace :assets do
  desc 'Deploy to a particular environment'
  task :deploy do
    client = Aws::S3::Resource.new(region: 'us-west-2')
    bucket = client.bucket(Rails.configuration.assets_bucket_name)
    AMA::Styles::Deployment.new(bucket: bucket, log_output: true).run
  end
end
