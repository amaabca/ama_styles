# frozen_string_literal: true

module AMA
  module Styles
    module Internal
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
          Rake::Task['assets:copy_raw_assets'].invoke
          if font_awesome_pro?
            Rake::Task['assets:fa5_pro'].invoke(
              Rails.configuration.font_awesome_pro_source_path,
              GEM_ROOT_PATH
            )
          end
          Rake::Task['assets:precompile'].invoke
        end

        def clobber_assets
          Rake::Task['assets:clobber'].invoke
        end

        def assets_path
          root_path.join('public', 'assets')
        end

        def assets_files
          Dir.glob("#{assets_path}/**/**", File::FNM_DOTMATCH).select do |file|
            File.file?(file)
          end
        end

        def font_awesome_pro?
          Rails.configuration.font_awesome_pro_source_path.present?
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
          upload_file(file: file, key: key, cache: false)
        end

        def digest_file
          File.basename(find_directory_manifest(assets_path.to_s))
        end

        def upload_file(opts = {})
          key = opts.fetch(:key)
          file = opts.fetch(:file)
          log('Uploading: '.colorize(:light_blue) + key)
          object = bucket.object(key)
          content_type = MIME::Types.type_for(object.key).first.to_s
          args = args_for(type: content_type, cache: opts.fetch(:cache, true))
          object.upload_file(file, args)
        end

        def request
          RestClient::Request.logged_request(
            method: :post,
            headers: request_headers,
            url: Rails.configuration.api_deployment_url,
            user: Rails.configuration.api_deployment_user,
            password: Rails.configuration.api_deployment_password,
            payload: { digest_file: File.join('assets', digest_file) }.to_json
          )
        rescue RestClient::RequestFailed => ex
          fail!(ex)
        end

        def args_for(opts = {})
          type = opts.fetch(:type)
          { content_type: type }.tap do |hash|
            if opts.fetch(:cache)
              hash[:expires] = cache_expiry
              hash[:cache_control] = 'public'
            end
          end
        end

        def cache_expiry
          (DateTime.current + FAR_FUTURE_CACHE_EXPIRATION).httpdate
        end

        def request_headers
          {
            accept: 'application/json',
            content_type: 'application/json'
          }
        end

        def fail!(exception)
          raise exception
        end
      end
    end
  end
end
