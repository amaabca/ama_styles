$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ama/styles/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "ama_styles"
  s.version = AMA::Styles::VERSION
  s.authors = [
    "Michael van den Beuken",
    "Ruben Estevez",
    "Jordan Babe",
    "Mathieu Gilbert",
    "Ryan Jones",
    "Darko Dosenovic",
    "Jonathan Weyermann",
    "Kayt Campbell",
    "Kathleen Robertson",
    "Jesse Doyle"
  ]
  s.email = [
    "michael.beuken@gmail.com",
    "ruben.a.estevez@gmail.com",
    "jorbabe@gmail.com",
    "mathieu.gilbert@ama.ab.ca",
    "ryan.michael.jones@gmail.com",
    "darko.dosenovic@ama.ab.ca",
    "jonathan.weyermann@ama.ab.ca",
    "kayt.campbell@ama.ab.ca",
    "kathleen.robertson@ama.ab.ca",
    "jesse.doyle@ama.ab.ca"
  ]
  s.homepage = "https:/github.com/amaabca"
  s.summary = "Shared stylesheet assets for https://*.ama.ab.ca"
  s.description = "AMA's shared stylesheets"
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2"
  s.add_dependency "sass-rails"
  s.add_dependency "uglifier"
  s.add_dependency "foundation-rails", "~> 6.2.4.0"
  s.add_dependency "font-awesome-sass"
  s.add_dependency "rest-client"
  s.add_dependency "aws-sdk"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
end
