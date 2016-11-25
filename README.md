# settings_bundle plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg?style=flat)](https://rubygems.org/gems/fastlane-plugin-settings_bundle)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/jdee/settings-bundle/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/jdee/settings-bundle.svg?style=svg)](https://circleci.com/gh/jdee/settings-bundle)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-settings_bundle`, run the following command:
```
fastlane add_plugin settings_bundle
```

## About settings_bundle

Fastlane plugin to update static settings in an iOS settings bundle

![Sample Settings Bundle](https://github.com/jdee/settings-bundle/blob/master/settings-bundle-example.png)

### update_settings_bundle

This action updates a specified NSUserDefaults key in the project's
`Settings.bundle` to a specified value. There are two macros that will
be expanded if included in the value argument. `:version` will be
replaced with the app's marketing version; `:build` will be replaced with
the current build number.

```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  key: "CurrentAppVersion",
  value: ":version (:build)"
)
```

This updates the key named `CurrentAppVersion` in the `Root.plist` in the
`Settings.bundle` to contain the marketing version and build number in the
specified format. Use the action this way after `increment_build_number` or
`increment_version_number` to update your settings bundle as part of a
version bump.

#### Files other than Root.plist

```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  file: "About.plist",
  key: "CurrentAppVersion",
  value: ":version (:build)"
)
```

The `file` argument specifies a file other than `Root.plist` in the
`Settings.bundle`. If you have multiple projects, keys or files,
run the action multiple times.

#### Key content

Any string is valid for the value. It need not contain either or
both the symbols mentioned. If it contains neither, the literal value
of the value argument will be used. This can be useful for including
other settings besides the version and build numbers.

```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  key: "BuildDate",
  value: Time.now.strftime("%Y-%m-%d")
)
```

#### Configuration parameter

A project can use different `Info.plist` files per configuration
(Debug, Release, etc.). However, a project only has a single settings
bundle. By default, this action uses the `Info.plist` file from the
Release configuration. If you want to use the `Info.plist` for a
different configuration, use a `configuration` parameter:

```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  key: "CurrentAppVersion",
  value: ":version (:build)",
  configuration: "Debug"
```

## Example

See the SettingsBundleExample subdirectory for a sample project that
makes use of this action.

First build and run the sample project on a simulator. It should show
you the current
version and build number: 1.0.0 (1). This info is taken from the main
bundle.

If you visit the Settings app and look at the settings for
SettingsBundleExample, you'll see the same version and build number
as well as a blank field for the Build date.

Now run Fastlane:

```bash
bundle install
bundle exec fastlane test
```

Now run the sample app again. It should display 1.0.0 (2). Visit the
Settings app under the settings for the app to see the update to the
settings bundle. The Build date field should show the current date.

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
