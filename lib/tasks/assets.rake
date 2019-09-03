# frozen_string_literal: true

namespace :assets do
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
end
