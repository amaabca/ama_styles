# frozen_string_literal: true

# The following dependencies will not be loaded when the engine is mounted
# in a host application.

# Development Dependencies
require 'rake'
require 'aws-sdk'
require 'rest-client'
require 'rest_client/jogger'
require 'slack-notifier'
require 'colorize'
require 'highline'
require 'git'

# Internal
require_relative 'config'
require_relative 'environment'
require_relative 'chat'
require_relative 'cli'
require_relative 'deployment'
require_relative 'commands/deploy'
require_relative 'commands/build'
