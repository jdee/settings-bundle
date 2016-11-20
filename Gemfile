source 'https://rubygems.org'

ruby "2.3.1"

gemspec

gem 'simplecov'
gem 'rspec-simplecov'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval(File.read(plugins_path), binding) if File.exist?(plugins_path)
