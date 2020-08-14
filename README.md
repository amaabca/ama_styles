# AmaStyles
Gem that will carry and deploy AMA assets.

## Getting Up and Running

1. Run `bundle install`
2. Setup the `.env` files by running these commands from the ama_styles directory:
  * `ln -s ~/src/rails_envs/ama_styles/.env.development .env.development`
  * `ln -s ~/src/rails_envs/ama_styles/.env.staging .env.staging`
  * `ln -s ~/src/rails_envs/ama_styles/.env.production .env.production`

## General Workflow

1. Checkout a new branch
2. Add your styles changes
3. Update the `ama_styles` gem version.
4. Commit and push
5. Review and merge
6. Deploy using
  1. `bin/assets ENVIRONMENT deploy` (Replace environment with: staging, production)

## Setup a new app

* Add `gem 'ama_styles', git: 'git@github.com:amaabca/ama_styles.git'` to your Gemfile.
* Extract any application-specific styles into `application.css` (remove any references to `ama_layout/application`).
* Add this line to your `layouts/application.html.erb` file (and any other layout files):

```erb
  <%= stylesheet_link_tag Rails.configuration.stylesheet_resolver.asset_path, media: "all" %>
```

* Add to config/application.rb: one version for all environments. If a version is
  not specified it will default to ama_styles_default_version.

```ruby
config.ama_styles_version = 'v3'
```

* Add to config/application.rb: different versions based on environment

```ruby
config.ama_styles_version = config.app_env == 'production' ? 'v2' : 'v3'
```

* Add to initializers/assets.rb

```ruby
  Rails.configuration.stylesheet_resolver.version = Rails.configuration.ama_styles_version # optional
  Rails.configuration.stylesheet_resolver.remote = Rails.env.production?
  Rails.configuration.assets.paths << File.join(
    Gem.loaded_specs['ama_styles'].full_gem_path,
    'app',
    'assets',
    'stylesheets',
    Rails.configuration.stylesheet_resolver.version
)
  Rails.configuration.assets.precompile += %W(#{Rails.configuration.stylesheet_resolver.version}/shared.css)
```
* Add the `ASSET_CLOUDFRONT_URL` variable to the relevant `.env` file for the application.
* Set the `cloudfront_url` configuration option in an initializer/application.rb:

```ruby
Rails.configuration.cloudfront_url = ENV['ASSET_CLOUDFRONT_URL']
```

## Local assets configuration
If you need to push a branch to production/staging you must disable remote assets under
initializers/assets.rb `Rails.configuration.stylesheet_resolver.remote = false`

This will trigger compilation of your assets instead of using AWS cloudfront.

** NOTE ** Remember to update ama_styles gem in the app after deploying to master to get new assets

## Font Awesome
To include the fontawesome all js in an application please add the following code to the desired application `app/assets/javascripts/application.js`

- Minified

```js
// = require ama_styles/font-awesome/all.min
```

- Regular

```js
// = require ama_styles/font-awesome/all
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
