# frozen_string_literal: true

require File.expand_path('../config/application', __FILE__)
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
load File.join('lib/tasks/assets.rake')
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
task default: %w[spec rubocop]
