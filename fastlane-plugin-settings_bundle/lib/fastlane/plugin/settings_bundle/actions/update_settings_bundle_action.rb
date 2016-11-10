require 'xcodeproj'

module Fastlane
  module Actions
    class UpdateSettingsBundleAction < Action
      def self.run(params)
        key = params[:key]

        # try to open project file (raises)
        project = Xcodeproj::Project.open params[:xcodeproj]

        helper = Helper::SettingsBundleHelper

        # TODO: Make configuration a parameter
        current_app_version = helper.formatted_version_from_info_plist project, "Release"

        # TODO: Make file a parameter
        helper.update_root_plist project, "Root.plist", key, current_app_version
      rescue => e
        UI.user_error! e.message
      end

      def self.description
        "Fastlane plugin action to update static settings in an iOS settings bundle"
      end

      def self.authors
        ["Jimmy Dee"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
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
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
