source 'https://rubygems.org'

gemspec
gem "fastlane", path: "~/github/jdee/fastlane"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval(File.read(plugins_path), binding) if File.exist?(plugins_path)
