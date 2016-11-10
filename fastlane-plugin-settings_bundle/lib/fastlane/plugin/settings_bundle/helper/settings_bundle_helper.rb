require 'plist'

module Fastlane
  module Helper
    class SettingsBundleHelper
      class << self
        def formatted_version_from_info_plist(project, configuration)
          # find the first non-test, non-extension target
          # TODO: Make this a :target parameter
          target = project.targets.find { |t| !t.test_target_type? && !t.extension_target_type? }

          # find the Info.plist paths for all configurations
          info_plist_paths = target.resolved_build_setting "INFOPLIST_FILE"

          # this can differ from one configuration to another.
          # take from Release, since only one Settings.bundle per project
          # (not per configuration)
          release_info_plist_path = info_plist_paths[configuration]

          # try to open and parse the Info.plist (raises)
          info_plist = Plist::parse_xml release_info_plist_path

          # increments already happened. read the current state.
          current_marketing_version = info_plist["CFBundleShortVersionString"]
          current_build_number = info_plist["CFBundleVersion"]

          # formatted string
          "#{current_marketing_version} (#{current_build_number})"
        end

        def update_root_plist(project, file, key, version)
          settings_bundle_path = project.files.find{ |f| f.path =~ /Settings.bundle/ }.path
          plist_path = File.join settings_bundle_path, file

          # raises
          settings_plist = Plist::parse_xml plist_path
          preference_specifiers = settings_plist["PreferenceSpecifiers"]

          # Find the specifier for the supplied key
          current_app_version_specifier = preference_specifiers.find do |specifier|
            specifier["Key"] == key
          end
        
          # Update to the new value
          current_app_version_specifier["DefaultValue"] = version
        
          # Save
          Plist::Emit.save_plist settings_plist, plist_path
        end
      end
    end
  end
end
