# frozen_string_literal: true

namespace :assets do
  desc 'Deploy to a particular environment'
  task :deploy do
    client = Aws::S3::Resource.new(region: 'us-west-2')
    bucket = client.bucket(Rails.configuration.assets_bucket_name)
    AMA::Styles::Internal::Deployment.new(bucket: bucket, log_output: true).run
  end

  desc 'Copy raw assets'
  task :copy_raw_assets do
    assets_path = File.join(Rails.root, 'app', 'assets', 'raw')
    assets = Dir.glob("#{assets_path}/**/**", File::FNM_DOTMATCH).map do |file|
      next unless File.file?(file)
      expanded_path = Pathname.new(File.expand_path(file))
      asset_path = Pathname.new(assets_path)
      expanded_path.relative_path_from(asset_path).to_s
    end.compact
    assets.each do |asset|
      source_file = File.join(assets_path, asset)
      dest_file = File.join(Rails.root, 'public', 'assets', 'raw', asset)
      FileUtils.mkdir_p(File.dirname(dest_file))
      FileUtils.copy_file source_file, dest_file, true
    end
  end

  desc 'Link FontAwesome 5 Pro into vendor/assets/fonts/font-awesome'
  task :fa5_pro, %i[source destination] do |_task, args|
    source_path = File.join(args[:source], '*.{eot,svg,ttf,woff,woff2}')
    font_wildcard = File.expand_path(source_path)
    destination = File.join(args[:destination], 'vendor', 'assets', 'fonts', 'font-awesome')
    destination_path = File.expand_path(destination)
    FileUtils.mkdir_p(destination)
    Dir.glob(font_wildcard).each do |file|
      FileUtils.ln_s(file, destination_path, force: true)
    end
  end
end
