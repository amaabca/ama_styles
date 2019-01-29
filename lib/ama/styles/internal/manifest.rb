# frozen_string_literal: true

module AMA
  module Styles
    module Internal
      class Manifest
        include Globals

        attr_accessor :bucket

        def initialize(opts = {})
          self.bucket = opts.fetch(:bucket)
        end

        def update!
          validate!
          collect_garbage
        end

        def asset_files
          assets.values.map { |_f| File.join(ASSET_PREFIX, MANIFEST_FILE) }
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
          required_file?(asset) || in_manifest?(asset)
        end

        def required_file?(asset)
          STATIC_FILES.include?(asset.key)
        end

        def in_manifest?(asset)
          asset_files.any? { |f| asset.key.match(f) }
        end

        def assets
          manifest.dig(:assets)
        end

        def manifest
          @manifest ||= begin
            file = File.join(ASSET_PREFIX, MANIFEST_FILE)
            JSON.parse(fetch_file(file)).with_indifferent_access
          end
        end

        def file_in_bucket?(file)
          raise StandardError, 'File missing!' unless object_keys.include?(file)
        end

        def object_keys
          @object_keys ||= bucket.objects.to_a.map(&:key)
        end

        def fetch_file(file, _opts = {})
          bucket.object(file).get.body.read
        end
      end
    end
  end
end
