source 'https://rubygems.org'

gemspec
gem "fastlane", git: "https://github.com/jdee/fastlane", branch: "commit-version-bump-enhancements"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval(File.read(plugins_path), binding) if File.exist?(plugins_path)
