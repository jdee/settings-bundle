### SettingsBundleLibraryExample (advanced)

The SettingsBundleLibraryExample project includes multiple targets with different versions
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
