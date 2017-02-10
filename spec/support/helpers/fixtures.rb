# frozen_string_literal: true

module Helpers
  module Fixtures
    PATH = File.join(
      Gem.loaded_specs['ama_styles'].full_gem_path,
      'spec',
      'fixtures'
    )

    def read_fixture(*path)
      File.read(File.join(PATH, *path))
    end
  end
end
