# frozen_string_literal: true

# Third Party
require 'rake'
require 'font-awesome-sass'
require 'foundation/rails'
require 'dotenv/rails-now'
require 'autoprefixer-rails'

# Internal
require 'ama/styles/base'
require 'ama/styles/resolver'
require 'ama/styles/engine'

load File.join(AMA::Styles::Globals::GEM_ROOT_PATH, 'lib/ama/tasks/assets.rake')
