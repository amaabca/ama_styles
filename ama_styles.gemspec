# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ama/styles/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'ama_styles'
  s.version = AMA::Styles::VERSION
  s.authors = [
    'Michael van den Beuken',
    'Ruben Estevez',
    'Jordan Babe',
    'Mathieu Gilbert',
    'Jesse Doyle',
    'Ryan Jones',
    'Darko Dosenovic',
    'Jonathan Weyermann',
    'Zoie Carnegie',
    'Kayt Campbell',
    'Kathleen Robertson',
    'Sinead Errity'
  ]
  s.email = [
    'michael.beuken@gmail.com',
    'ruben.a.estevez@gmail.com',
    'jorbabe@gmail.com',
    'mathieu.gilbert@ama.ab.ca',
    'jesse.doyle@ama.ab.ca',
    'ryan.michael.jones@gmail.com',
    'darko.dosenovic@ama.ab.ca',
    'jonathan.weyermann@ama.ab.ca',
    'zoie.carnegie@ama.ab.ca',
    'kayt.campbell@ama.ab.ca',
    'kathleen.robertson@ama.ab.ca',
    'sinead.errity@ama.ab.ca'
  ]
  s.homepage = 'https:/github.com/amaabca/ama_styles'
  s.summary = 'Shared stylesheet assets for https://*.ama.ab.ca'
  s.description = 'AMA\'s shared stylesheets'
  s.license = 'MIT'

  s.files = `git ls-files -z`.split("\x0")
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 4.2'
  s.add_dependency 'foundation-rails', '>= 6.4.1.2'
  s.add_dependency 'sass-rails'
  s.add_dependency 'font-awesome-sass'
  s.add_dependency 'redis-rails'
  s.add_dependency 'dotenv-rails'
  s.add_dependency 'autoprefixer-rails'

  s.add_development_dependency 'aws-sdk'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '0.49.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'colorize'
  s.add_development_dependency 'hipchat', '~> 1.5.4'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rest-client'
  s.add_development_dependency 'rest-client-jogger'
  s.add_development_dependency 'highline'
  s.add_development_dependency 'git'
end
