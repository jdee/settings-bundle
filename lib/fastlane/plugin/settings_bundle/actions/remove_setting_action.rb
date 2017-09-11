# Copyright (c) 2016-17 Jimmy Dee
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
    class RemoveSettingAction < Action
      def self.run(params)
        key = params[:key]
        file = params[:file]

        helper = Helper::SettingsBundleHelper

        xcodeproj_path = helper.xcodeproj_path_from_params params
        # Error already reported in helper
        return if xcodeproj_path.nil?

        # try to open project file (raises)
        project = Xcodeproj::Project.open xcodeproj_path      

        # raises
        helper.remove_settings_plist_title_setting project, params[:bundle_name], file, key

      rescue => e
        UI.user_error! "#{e.message}\n#{e.backtrace}"
      end

      def self.description
        "Fastlane plugin action to remove settings in an iOS settings bundle"
      end

      def self.author
        "Colin Harris"
      end

      def self.details
        "This action is used to automatically delete an entry \n" \
          "in an app's Settings bundle. It can be used to remove settings \n." \
          "that you do not want to make available in some environments."
      end

      def self.available_options
        [
          # Required parameters
          FastlaneCore::ConfigItem.new(key: :key,
                                  env_name: "SETTINGS_BUNDLE_KEY",
                               description: "The user defaults key to update in the settings bundle",
                                  optional: false,
                                      type: String),          

          # Optional parameters
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                  env_name: "SETTINGS_BUNDLE_XCODEPROJ",
                               description: "An Xcode project file whose settings bundle to update",
                                  optional: true,
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
                                      type: String)
        ]
      end

      def self.example_code
        [
          <<-EOF
            remove_setting(
              key: "ItemToRemove"
            )
          EOF,
          <<-EOF
            remove_setting(
              xcodeproj: "MyProject.xcodeproj",
              key: "ItemToRemove",
            )
          EOF,
          <<-EOF
            remove_setting(
              file: "About.plist",
              key: "ItemToRemove"
            )
          EOF,                    
          <<-EOF
            remove_setting(
              key: "ItemToRemove",
              bundle_name: "MySettings.bundle"
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
