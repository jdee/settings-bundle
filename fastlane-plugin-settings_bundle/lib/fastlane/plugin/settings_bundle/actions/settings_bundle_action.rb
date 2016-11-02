module Fastlane
  module Actions
    class SettingsBundleAction < Action
      def self.run(params)
        UI.message("The settings_bundle plugin is working!")
      end

      def self.description
        "Fastlane plugin to update static settings in an iOS settings bundle"
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
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "SETTINGS_BUNDLE_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
