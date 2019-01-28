module AMA
  module Styles
    module Internal
      class Manifest
        include S3::Client

        def update!
          validate!
          collect_garbage
        end

        def asset_files
          assets.values.map { |f| File.join(ASSET_PREFIX, f) }
        end

        def validate!
          # We request every asset here as a sanity check. If we're going
          # to flip all applications over, we want to make sure the files
          # are in place first.
          asset_files.each { |f| file_in_bucket?(f) }
        end

        private

        def collect_garbage
          bucket.objects.each do |asset|
            asset.delete unless used_file?(asset)
          end
        end

        def used_file?(asset)
          fallback_file?(asset) || manifest_file?(asset) || in_manifest?(asset)
        end

        def fallback_file?(asset)
          !!asset.key.match(FALLBACK_STYLESHEET_FILE)
        end

        def manifest_file?(asset)
          asset.key == 'manifest'
        end

        def in_manifest?(asset)
          asset_files.any? { |f| asset.key.match(f) }
        end

        def assets
          manifest.dig(:assets)
        end

        def manifest
          @manifest ||= JSON.parse(fetch_file('manifest')).with_indifferent_access
        end

        def file_in_bucket?(file)
          missing_file!(file) unless object_keys.include?(file)
        end

        def object_keys
          @object_keys ||= bucket.objects.to_a.map(&:key)
        end

        def fetch_file(file, opts = {})
          bucket.object(file).get.body.read
        rescue Aws::S3::Errors::ServiceError
          missing_file!(file)
        end

        def missing_file!(file)
          raise MissingFileError, I18n.t('assets.errors.missing_file', file: file)
        end
      end
    end
  end
end
