# frozen_string_literal: true

require File.expand_path('../config/application', __FILE__)
require_relative 'lib/ama/styles/cli_base'
require_relative 'lib/ama/styles/deployment'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
AMA::Styles::Application.load_tasks
AMA::Styles::Application.initialize!
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
task default: [:spec, :rubocop]
