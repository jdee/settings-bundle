# settings_bundle plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg?style=flat-square)](https://rubygems.org/gems/fastlane-plugin-settings_bundle)
[![Gem](https://img.shields.io/gem/v/fastlane-plugin-settings_bundle.svg?style=flat)](https://rubygems.org/gems/fastlane-plugin-settings_bundle)
[![Downloads](https://img.shields.io/gem/dt/fastlane-plugin-settings_bundle.svg?style=flat)](https://rubygems.org/gems/fastlane-plugin-settings_bundle)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/jdee/settings-bundle/blob/master/LICENSE)
[![CircleCI](https://img.shields.io/circleci/project/github/jdee/settings-bundle.svg)](https://circleci.com/gh/jdee/settings-bundle)

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
)
```

#### Target parameter

By default, this action takes the settings from the first non-test, non-extension target in
the project. Use the optional :target parameter to specify a target by name.
```ruby
update_settings_bundle(
  xcodeproj: "MyProject.xcodeproj",
  key: "CurrentAppVersion",
  value: ":version (:build)",
  target: "MyAppTarget"
)
```

## Examples

[SettingsBundleExample]: ./examples/SettingsBundleExample
[SettingsBundleLibraryExample]: ./examples/SettingsBundleLibraryExample

There are two examples in the `examples` subdirectory: [SettingsBundleExample] (basic) and
[SettingsBundleLibraryExample] (advanced).

### SettingsBundleExample (basic)

See the `examples/SettingsBundleExample` subdirectory for a simple example project that
makes use of this action.

First build and run the sample project on a simulator or device. It should show
you the current
version and build number: 1.0.0 (1). This information is taken from the app's Info.plist.

Tap the version number to view the settings for
SettingsBundleExample in the Settings app. You'll see the same version and build number
as well as a blank field for the Build date.

Now run Fastlane:

```bash
bundle install
bundle exec fastlane test
```

Run the sample app again. It should display 1.0.0 (2). Tap the version number again
to see the update to the
settings bundle. The Build date field should show the current date.

### SettingsBundleLibraryExample (advanced)

The [SettingsBundleLibraryExample] project includes multiple targets with different versions
and a settings bundle with multiple pages. In addition to the `SettingsBundleLibraryExample`
target, there is a `SettingsBundleExampleFramework`, which builds a framework that is embedded
in the application. The app version is 1.0.0. The framework version is 1.0.1.

The settings bundle includes a child pane in Framework.plist. The app version (CurrentAppVersion)
and build date are in the Root.plist. The framework version (CurrentFrameworkVersion) is in
Framework.plist. It appears on the "Framework settings" page in the Settings app.

The lane in the Fastfile makes use of the :target parameter to choose which version data to use.

To update this project:

```bash
bundle exec fastlane library_test
```

Now build and run the app. The settings have been updated with the appropriate version
for each component.

#### Note

Though you can use a different version in
the `Info.plist` for each target, `agvtool` will
automatically set them all to the same value on update.
If you do your version update using a different
mechanism, `:build` will refer to the `CFBundleVersion` from the `Info.plist`
for whichever target you use.

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
