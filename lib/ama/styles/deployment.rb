# frozen_string_literal: true
module AMA
  module Styles
    class Deployment
      include ActiveModel::Model
      include Sprockets::ManifestUtils
      include Globals

      STYLESHEET_PATTERN = "#{PRIMARY_STYLESHEET_NAME}*.css"

      attr_accessor :log_output, :bucket

      def run
        sprockets_tasks
        upload_files
        log('Generating fallback stylesheet...'.colorize(:yellow))
        upload_fallback_stylesheet
        log('Verifying S3 integrity...'.colorize(:yellow))
        request
        log('SUCCESS!'.colorize(:green) + ' 🎨')
      end

      # Shamelessly taken from:
      # https://github.com/rails/sprockets-rails/blob/
      # 830e2d9c15fb1506f4b39c5b9b81ffd48f7c0534/test/test_railtie.rb#L7-L13
      def silence_stderr
        orig_stderr = $stderr.clone
        $stderr.reopen File.new('/dev/null', 'w')
        yield
      ensure
        $stderr.reopen orig_stderr
      end

      private

      def sprockets_tasks
        silence_stderr do
          clobber_assets
          log('Precompiling assets and pushing to S3...'.colorize(:yellow))
          precompile_assets
        end
      end

      def log(msg)
        puts msg if log_output
      end

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
        Dir.glob("#{assets_path}/**/**", File::FNM_DOTMATCH).select do |file|
          File.file?(file)
        end
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
        file = Dir.glob(File.join(assets_path, STYLESHEET_PATTERN)).first
        upload_file(file: file, key: key)
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
        log('Uploading: '.colorize(:light_blue) + key)
        object = bucket.object(key)
        object.upload_file(file)
      end

      def request
        RestClient::Request.execute(
          method: :post,
          headers: request_headers,
          url: api_url,
          user: Rails.configuration.api_deployment_user,
          password: Rails.configuration.api_deployment_password,
          payload: { digest_file: File.join('assets', digest_file) }.to_json
        )
      end

      def request_headers
        {
          accept: 'application/json',
          content_type: 'application/json'
        }
      end
    end
  end
end
