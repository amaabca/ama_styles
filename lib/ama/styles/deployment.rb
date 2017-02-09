module AMA
  module Styles
    class Deployment
      include ActiveModel::Model
      include Sprockets::ManifestUtils
      include Globals

      def run
        clobber_assets
        puts 'Precompiling assets and pushing to S3...'.colorize(:yellow)
        precompile_assets
        upload_files
        puts 'Generating fallback stylesheet...'.colorize(:yellow)
        upload_fallback_stylesheet
        puts "Verifying S3 integrity...".colorize(:yellow)
        request
        puts "SUCCESS!".colorize(:green) + ' 🎨'
      end

    private

      def precompile_assets
        Rake::Task['assets:precompile'].invoke
      end

      def clobber_assets
        Rake::Task['assets:clobber'].invoke
      end

      def assets_path
        Pathname.new File.join(ROOT_PATH, 'public', 'assets')
      end

      def assets_files
        Dir.glob("#{assets_path.to_s}/**/**", File::FNM_DOTMATCH).select { |f| File.file?(f) }
      end

      def upload_files
        assets_files.each do |file|
          path = Pathname.new(file)
          key = File.join('assets', path.relative_path_from(assets_path).to_s)
          upload_file(file: file, key: key)
        end
      end

      def upload_fallback_stylesheet
        key = File.join(ASSET_PREFIX, FALLBACK_STYLESHEET_FILE)
        file = Dir.glob(File.join(assets_path, "#{PRIMARY_STYLESHEET_NAME}*.css")).first
        upload_file(file: file, key: key)
      end

      def s3_client
        @s3_client ||= Aws::S3::Resource.new(region: 'us-west-2')
      end

      def api_url
        Rails.configuration.api_deployment_url
      end

      def digest_file
        File.basename(find_directory_manifest(assets_path.to_s))
      end

      def upload_file(opts = {})
        key = opts.fetch(:key)
        file = opts.fetch(:file)
        puts 'Uploading: '.colorize(:light_blue) + key
        object = s3_client.bucket(Rails.configuration.assets_bucket_name).object(key)
        object.upload_file(file)
      end

      def request
        RestClient::Request.execute(
          method: :post,
          headers: {
            accept: 'application/json',
            content_type: 'application/json'
          } ,
          url: api_url,
          user: Rails.configuration.api_deployment_user,
          password: Rails.configuration.api_deployment_password,
          payload: { digest_file: File.join('assets', digest_file) }.to_json
        )
      end
    end
  end
end
