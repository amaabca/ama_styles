# frozen_string_literal: true

# The following dependencies will not be loaded when the engine is mounted
# in a host application.

# Development Dependencies
require 'rake'
require 'aws-sdk'
require 'rest-client'
require 'rest_client/jogger'
require 'hipchat'
require 'colorize'
require 'highline'
require 'git'

# Internal
require_relative 'config'
require_relative 'hipchat'
require_relative 'cli'
require_relative 'deployment'
require_relative 'commands/deploy'
