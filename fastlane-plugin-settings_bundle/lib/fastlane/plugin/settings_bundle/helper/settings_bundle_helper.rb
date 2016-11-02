module Fastlane
  module Helper
    class SettingsBundleHelper
      # class methods that you define here become available in your action
      # as `Helper::SettingsBundleHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the settings_bundle plugin helper!")
      end
    end
  end
end
