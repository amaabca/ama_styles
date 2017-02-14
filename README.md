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
3. Commit and push
4. Review and merge
5. Deploy using
  1. bin/assets ENVIRONMENT deploy (Replace environment with: staging, production)

## Setup a new app

1. Add `gem 'ama_styles'` to your Gemfile
2. Remove the application.css (extract any application specific styles to a new stylesheet link tag)
3. Replace the application stylesheet link tag on every layout file with:
    ```ruby
      = stylesheet_link_tag Rails.configuration.stylesheet_resolver.asset_path, media: "all"
    ```
4. Add to initializers/assets.rb `Rails.configuration.stylesheet_resolver.remote = Rails.env.production?`
5. Add the cloudfront_url to the rails configuration

## Local assets configuration
If you need to push a branch to production/staging you must disable remote assets under
initializers/assets.rb `Rails.configuration.stylesheet_resolver.remote = false`

This will trigger compilation of your assets instead of using AWS cloudfront.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
