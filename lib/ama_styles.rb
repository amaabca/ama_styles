# frozen_string_literal: true

# Third Party
require 'font-awesome-sass'
require 'foundation/rails'
require 'aws-sdk'
require 'rest-client'
require 'dotenv/rails-now'
require 'hipchat'
require 'colorize'
require 'rake'
require 'highline'
require 'git'

# Internal
require 'ama/styles/base'
require 'ama/styles/hipchat'
require 'ama/styles/deployment'
require 'ama/styles/resolver'
require 'ama/styles/engine'
require 'ama/styles/cli'
require 'ama/styles/commands/deploy'
