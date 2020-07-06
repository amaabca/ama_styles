# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.eager_load = false
Rails.application.config.assets.css_compressor = :sass
Rails.application.config.assets.precompile += %w(v2/shared.css v3/shared.css)
