# settings_bundle plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-settings_bundle)

# Work in progress

This plugin is currently unfinished and unreleased. See [this issue](https://github.com/jdee/settings-bundle/issues/1) for general discussion.

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-settings_bundle`, 
add the following line to your Pluginfile until the gem is published:
```
gem "fastlane-plugin-settings_bundle", git: "https://github.com/jdee/settings-bundle"
```

## About settings_bundle

Fastlane plugin to update static settings in an iOS settings bundle

### update_settings_bundle

This action updates a specified NSUserDefaults key in the project's
`Settings.bundle` to the current app version, including the marketing
version and the build number. Use it after `increment_build_number` or
`increment_version_number`.

```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  key: "CurrentAppVersion"
)
```

This updates the key named `CurrentAppVersion` in the `Root.plist` in the
`Settings.bundle`.

```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  file: "About.plist",
  key: "CurrentAppVersion"
)
```

The `file` argument specifies a file other than `Root.plist` in the
`Settings.bundle`. If you have multiple projects, keys or files,
run the action multiple times.

#### Custom formats

You can also override the default format using an optional format
argument containing the symbols `:version` and `:build`. The default
format is `":version (:build)"`.

```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  key: "CurrentAppVersion",
  format: ":version-:build"
)
```

Any occurrence of `:version` will be replaced with the marketing version
from the project. Any occurrence of `:build` will be replaced with the
build number. For example, the default format results in a formatted
version like `1.0.0 (1)`.

Any string is valid for the format. It need not contain either or
both the symbols mentioned. If it contains neither, the literal value
of the format argument will be returned.

## Example

See the SettingsBundleExample subdirectory for a sample project that
makes use of this action.

First build and run the sample project. It should show you the current
version and build number: 1.0.0 (1).

```bash
bundle install
bundle exec fastlane update
```

Now run the sample app again. It should display 1.0.0 (2). Visit the
Settings app under the settings for the app to see the update to the
settings bundle.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
