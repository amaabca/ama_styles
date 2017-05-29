# frozen_string_literal: true

require File.expand_path('../config/application', __FILE__)
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
task default: %w[spec rubocop]
