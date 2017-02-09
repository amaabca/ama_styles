module AMA
  module Styles
    class Deployment
      include ActiveModel::Model
      include Sprockets::ManifestUtils

      def run
        clobber_assets
        precompile_assets
        upload_files
        request
      end

    private

      def precompile_assets
        Rake::Task['assets:precompile'].execute
      end

      def clobber_assets
        Rake::Task['assets:clobber'].execute
      end

      def assets_path
        Pathname.new File.join(Globals::ROOT_PATH, 'public', 'assets')
      end

      def assets_files
        Dir.glob("#{assets_path.to_s}/**/**", File::FNM_DOTMATCH).select { |f| File.file?(f) }
      end

      def upload_files
        assets_files.each do |file|
          path = Pathname.new(file)
          key = File.join('assets', path.relative_path_from(assets_path).to_s)
          obj = s3_client.bucket(Rails.configuration.assets_bucket_name).object(key)
          puts 'Uploading: '.colorize(:green) + key
          obj.upload_file(file)
        end
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

      def request
        RestClient::Request.execute(
          method: :post,
          headers: {
            accept: 'application/json',
            content_type: 'application/json'
          } ,
          url: api_url,
          payload: { digest_file: File.join('assets', digest_file) }.to_json
        )
      end
    end
  end
end
