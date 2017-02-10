# frozen_string_literal: true

Rails.configuration.assets.css_compressor = :sass
Rails.configuration.assets.precompile += %w(shared.css)
