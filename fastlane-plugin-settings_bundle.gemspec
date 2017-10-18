# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/settings_bundle/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-settings_bundle'
  spec.version       = Fastlane::SettingsBundle::VERSION
  spec.author        = 'Jimmy Dee'
  spec.email         = 'jgvdthree@gmail.com'

  spec.summary       = 'Fastlane plugin to update static settings in an iOS settings bundle'
  spec.homepage      = "https://github.com/jdee/settings-bundle"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w[README.md LICENSE]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'plist'
  spec.add_dependency 'xcodeproj', '>= 1.4.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rspec-simplecov'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'fastlane', '>= 2.39.0'
end
