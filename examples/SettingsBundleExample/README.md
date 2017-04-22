### SettingsBundleExample (basic)

This is a simple example project that makes use of the
update_settings_bundle action.

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
