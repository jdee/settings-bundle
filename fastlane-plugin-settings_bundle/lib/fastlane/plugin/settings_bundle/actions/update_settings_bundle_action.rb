require 'xcodeproj'

module Fastlane
  module Actions
    class UpdateSettingsBundleAction < Action
      def self.run(params)
        key = params[:key]
        configuration = params[:configuration]
        file = params[:file]

        # try to open project file (raises)
        project = Xcodeproj::Project.open params[:xcodeproj]

        helper = Helper::SettingsBundleHelper

        current_app_version = helper.formatted_version_from_info_plist project, configuration

        helper.update_settings_plist_title_setting project, file, key, current_app_version
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
          FastlaneCore::ConfigItem.new(key: :file,
                                  env_name: "SETTINGS_BUNDLE_FILE",
                               description: "The plist file in the Settings.bundle to update",
                                  optional: true,
                             default_value: "Root.plist",
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
