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
        file = params[:file]
        format = params[:format]

        # try to open project file (raises)
        project = Xcodeproj::Project.open params[:xcodeproj]

        helper = Helper::SettingsBundleHelper

        current_app_version = helper.formatted_version_from_info_plist project,
          configuration, format

        helper.update_settings_plist_title_setting project, file, key,
          current_app_version
      rescue => e
        UI.user_error! e.message
      end

      def self.description
        "Fastlane plugin action to update static settings in an iOS settings bundle"
      end

      def self.authors
        ["Jimmy Dee"]
      end

      def self.details
        # Optional:
        "More to come"
      end

      def self.available_options
        [
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
          FastlaneCore::ConfigItem.new(key: :configuration,
                                  env_name: "SETTINGS_BUNDLE_CONFIGURATION",
                               description: "The build configuration to use for the Info.plist file",
                                  optional: true,
                             default_value: "Release",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :format,
                                  env_name: "SETTINGS_BUNDLE_FORMAT",
                               description: "Specifies how to format the version and build number",
                                  optional: true,
                             default_value: ":version (:build)",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :file,
                                  env_name: "SETTINGS_BUNDLE_FILE",
                               description: "The plist file in the Settings.bundle to update",
                                  optional: true,
                             default_value: "Root.plist",
                                      type: String)
        ]
      end

      def self.example_code
        [
          <<-EOF
            update_settings_bundle(
              xcodeproj: "MyProject.xcodeproj",
              key: "CurrentAppVersion"
            )
          EOF,
          <<-EOF
            update_settings_bundle(
              xcodeproj: "MyProject.xcodeproj",
              file: "About.plist",
              key: "CurrentAppVersion"
            )
          EOF
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
