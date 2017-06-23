$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "data_pitcher/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "data_pitcher"
  s.version     = DataPitcher::VERSION
  s.authors     = ["Masahiro Nishimi"]
  s.email       = ["nishimi@sonicgarden.jp"]
  s.homepage    = "https://github.com/mahm/data_pitcher"
  s.summary     = "Data Pitcher throw your pesisted data to Google Spreadsheet."
  s.description = "Data Pitcher throw your pesisted data to Google Spreadsheet."
  s.license     = "MIT"

  s.files       = `git ls-files`.split($\)

  s.required_ruby_version = ">= 2.3"
  s.add_runtime_dependency "activerecord", ">= 3.2"
  s.add_runtime_dependency "google_drive"
  s.add_development_dependency "rake"
end
