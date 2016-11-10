require 'plist'

module Fastlane
  module Helper
    class SettingsBundleHelper
      class << self
        # Takes an open Xcodeproj::Project and extracts the current
        # marketing version and build number as a formatted string.
        # The format is "#{marketing_version} (#{build_number})".
        # Raises on error.
        #
        # :project: An open Xcodeproj::Project via Xcodeproj::Project.open, e.g.
        # :configuration: A valid build configuration in the project
        def formatted_version_from_info_plist(project, configuration)
          # find the first non-test, non-extension target
          # TODO: Make this a :target parameter
          target = project.targets.find { |t| !t.test_target_type? && !t.extension_target_type? }
          raise "No application target found" if target.nil?

          # find the Info.plist paths for all configurations
          info_plist_paths = target.resolved_build_setting "INFOPLIST_FILE"

          raise "INFOPLIST_FILE not found in target" if info_plist_paths.nil? or info_plist_paths.empty?

          # this can differ from one configuration to another.
          # take from Release, since only one Settings.bundle per project
          # (not per configuration)
          release_info_plist_path = info_plist_paths[configuration]

          raise "Info.plist not found for configuration #{configuration}" if release_info_plist_path.nil?

          # try to open and parse the Info.plist (raises)
          info_plist = Plist.parse_xml release_info_plist_path

          # increments already happened. read the current state.
          current_marketing_version = info_plist["CFBundleShortVersionString"]
          current_build_number = info_plist["CFBundleVersion"]

          raise "CFBundleShortVersionString not found in Info.plist" if current_marketing_version.nil?
          raise "CFBundleVersion not found in Info.plist" if current_build_number.nil?

          # formatted string
          # TODO: Allow customization
          "#{current_marketing_version} (#{current_build_number})"
        end

        # Takes an open Xcodeproj::Project, extracts the settings bundle
        # and updates the specified setting key in the specified file
        # to the specified value. Only valid for title items. Raises
        # on error.
        #
        # :project: An open Xcodeproj::Project, obtained from Xcodeproj::Project.open, e.g.
        # :file: A settings plist file in the Settings.bundle, usually "Root.plist"
        # :key: A valid NSUserDefaults key in the Settings.bundle
        # :value: A new value for the key
        def update_settings_plist_title_setting(project, file, key, value)
          settings_bundle_path = project.files.find { |f| f.path =~ /Settings.bundle/ }.path

          raise "Settings.bundle not found in project" if settings_bundle_path.nil?

          plist_path = File.join settings_bundle_path, file

          # raises
          settings_plist = Plist.parse_xml plist_path
          preference_specifiers = settings_plist["PreferenceSpecifiers"]

          raise "#{file} is not a settings plist file" if preference_specifiers.nil?

          # Find the specifier for the supplied key
          title_specifier = preference_specifiers.find do |specifier|
            specifier["Key"] == key
          end

          raise "preference specifier for key #{key} not found in #{file}" if title_specifier.nil?
          raise "preference for key #{key} must be of type title" unless title_specifier["Type"] == "PSTitleValueSpecifier"

          # Update to the new value. Old value need not be present.
          title_specifier["DefaultValue"] = value.to_s

          # Save (raises)
          Plist::Emit.save_plist settings_plist, plist_path
        end
      end
    end
  end
end
