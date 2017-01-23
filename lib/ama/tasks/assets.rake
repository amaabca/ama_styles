namespace :assets do
  desc "Return the current asset digest"
  task current_digest: :environment do
    puts AMA::Styles::Application.assets['application.css'].digest
  end

  # NOTE: This is super hacky - it's just a proof of cocept to show
  # how such a system might work. We should also handle the creation
  # of a fallback asset deployment as well here...
  desc "Deploy to a particular environment"
  task :deploy, [:stage] => :environment do |_, args|
    raise ArgumentError, 'must specify a stage' unless args.stage.present?
    Rake::Task['assets:precompile'].execute
    digest = AMA::Styles::Application.assets['application.css'].digest
    assets_path = File.expand_path('~/src/ama_styles/public')
    assets_pathname = Pathname.new(assets_path)

    # Send Files to S3
    s3 = Aws::S3::Resource.new(region: 'us-west-2')
    # Strip out all directory names (we only want files here)
    # We also want the .sprockets manifest file so we can cleanup in the future
    files = Dir.glob("#{assets_path}/assets/**/**", File::FNM_DOTMATCH).select { |f| File.file?(f) }
    files.each do |file|
      path = Pathname.new(file)
      key = path.relative_path_from(assets_pathname).to_s
      obj = s3.bucket('ama-styles-concept').object(key)
      puts "Uploading: #{key}"
      obj.upload_file(file)
    end

    # Notify API of style change
    api_url = case args.first
              when 'production'
                'https://api.ama.ab.ca/styles/deploy.json'
              when 'staging'
                'https://stage-api.ama.ab.ca/styles/deploy.json'
              else # development
                'http://api.dev.ama.ab.ca/styles/deploy.json'
              end

    RestClient::Request.execute(
      method: :post,
      headers: {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      } ,
      url: api_url,
      payload: { revision: digest }
    )
  end
end
