# Copyright (c) 2016 Jimmy Dee
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

module Fastlane
  module Actions
    class UpdateSettingsBundleAction < Action
      def self.run(params)
        key = params[:key]
        configuration = params[:configuration]
        target_name = params[:target]
        file = params[:file]
        value = params[:value]

        # try to open project file (raises)
        project = Xcodeproj::Project.open params[:xcodeproj]

        helper = Helper::SettingsBundleHelper

        # raises
        settings = helper.settings_from_project project, configuration, target_name

        formatted_value = helper.formatted_value value, settings

        # raises
        helper.update_settings_plist_title_setting project, params[:bundle_name], file, key,
                                                   formatted_value
      rescue => e
        UI.user_error! "#{e.message}\n#{e.backtrace}"
      end

      def self.description
        "Fastlane plugin action to update static settings in an iOS settings bundle"
      end

      def self.author
        "Jimmy Dee"
      end

      def self.details
        "This action is used to automatically update a Title entry in a plist\n" \
          "in an app's Settings bundle. It can be used to update the current\n" \
          "version and/or build number automatically after they have been \n" \
          "updated, e.g. by the increment_version_number or increment_build_number\n" \
          "actions."
      end

      def self.available_options
        [
          # Required parameters
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                  env_name: "SETTINGS_BUNDLE_XCODEPROJ",
                               description: "An Xcode project file whose settings bundle to update",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :key,
                                  env_name: "SETTINGS_BUNDLE_KEY",
                               description: "The user defaults key to update in the settings bundle",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :value,
                                  env_name: "SETTINGS_BUNDLE_VALUE",
                               description: "Value to set with optional :version and :build included",
                                  optional: false,
                                      type: String),

          # Optional parameters
          FastlaneCore::ConfigItem.new(key: :configuration,
                                  env_name: "SETTINGS_BUNDLE_CONFIGURATION",
                               description: "The build configuration to use for the Info.plist file",
                                  optional: true,
                             default_value: "Release",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :file,
                                  env_name: "SETTINGS_BUNDLE_FILE",
                               description: "The plist file in the Settings.bundle to update",
                                  optional: true,
                             default_value: "Root.plist",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :bundle_name,
                                  env_name: "SETTINGS_BUNDLE_BUNDLE_NAME",
                               description: "The name of the settings bundle in the project (default Settings.bundle)",
                                  optional: true,
                             default_value: "Settings.bundle",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :target,
                                  env_name: "SETTINGS_BUNDLE_TARGET",
                               description: "An optional target name from the project",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.example_code
        [
          <<-EOF
            update_settings_bundle(
              xcodeproj: "MyProject.xcodeproj",
              key: "CurrentAppVersion",
              value: ":version (:build)"
            )
          EOF,
          <<-EOF
            update_settings_bundle(
              xcodeproj: "MyProject.xcodeproj",
              file: "About.plist",
              key: "CurrentAppVersion",
              value: ":version (:build)"
            )
          EOF,
          <<-EOF
            update_settings_bundle(
              xcodeproj: "MyProject.xcodeproj",
              key: "BuildDate",
              value: Time.now.strftime("%Y-%m-%d")
            )
          EOF,
          <<-EOF
            update_settings_bundle(
              xcodeproj: "MyProject.xcodeproj",
              key: "CurrentAppVersion",
              value: ":version (:build)",
              configuration: "Debug"
            )
          EOF,
          <<-EOF
            update_settings_bundle(
              xcodeproj: "MyProject.xcodeproj",
              key: "CurrentAppVersion",
              value: ":version (:build)",
              target: "MyAppTarget"
            )
          EOF
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.category
        :project
      end
    end
  end
end
