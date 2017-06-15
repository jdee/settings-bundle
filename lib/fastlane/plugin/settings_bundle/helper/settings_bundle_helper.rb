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

require 'plist'

module Fastlane
  module Helper
    UI = FastlaneCore::UI
    class SettingsBundleHelper
      Settings = Struct.new "Settings", :version, :build

      class << self
        # Takes a value, a version number and a build number and
        # returns a formatted string.
        # :version is replaced by the version number. :build
        # is replaced by the build number. Neither the version nor
        # the build number is required. Omitting both from the
        # format will result in the format being returned as the value.
        #
        # :value: A string value containing :version, :build, neither or both
        # :settings: A Settings struct containing settings from a project
        def formatted_value(value, settings)
          value.gsub(/:version/, settings.version.to_s).gsub(/:build/, settings.build.to_s)
        end

        # Takes an open Xcodeproj::Project and extracts the current
        # settings, returning a Settings struct with settings data.
        # Raises on error.
        #
        # :project: An open Xcodeproj::Project via Xcodeproj::Project.open, e.g.
        # :configuration: A valid build configuration in the project
        # :target_name: A valid target name in the project or nil to use the first application target
        def settings_from_project(project, configuration, target_name)
          if target_name
            target = project.targets.find { |t| t.name == target_name }
            raise "Target named \"#{target_name}\" not found" if target.nil?
          else
            # find the first non-test, non-extension target
            # TODO: Make this a :target parameter
            target = project.targets.find { |t| !t.test_target_type? && !t.extension_target_type? }
            raise "No application target found" if target.nil?
          end

          # find the Info.plist paths for all configurations
          info_plist_paths = target.resolved_build_setting "INFOPLIST_FILE"

          raise "INFOPLIST_FILE not found in target" if info_plist_paths.nil? or info_plist_paths.empty?

          # this can differ from one configuration to another.
          # take from Release, since only one Settings.bundle per project
          # (not per configuration)
          release_info_plist_path = info_plist_paths[configuration]

          raise "Info.plist not found for configuration #{configuration}" if release_info_plist_path.nil?

          project_parent = File.dirname project.path

          release_info_plist_path = File.join project_parent, release_info_plist_path

          # try to open and parse the Info.plist. raises on failure.
          info_plist = File.open(release_info_plist_path) { |f| Plist.parse_xml f }
          raise "Failed to parse plist file #{release_info_plist_path}" if info_plist.nil?

          # increments already happened. read the current state.
          current_marketing_version = info_plist["CFBundleShortVersionString"]
          current_build_number = info_plist["CFBundleVersion"]

          raise "CFBundleShortVersionString not found in Info.plist" if current_marketing_version.nil?
          raise "CFBundleVersion not found in Info.plist" if current_build_number.nil?

          Settings.new current_marketing_version, current_build_number
        end

        # Takes an open Xcodeproj::Project, extracts the settings bundle
        # and updates the specified setting key in the specified file
        # to the specified value. Only valid for title items. Raises
        # on error.
        #
        # :project: An open Xcodeproj::Project, obtained from Xcodeproj::Project.open, e.g.
        # :bundle_name: (String) Regex to identify the bundle to look for, usually Settings.bundle.
        # :file: A settings plist file in the Settings.bundle, usually "Root.plist"
        # :key: A valid NSUserDefaults key in the Settings.bundle
        # :value: A new value for the key
        def update_settings_plist_title_setting(project, bundle_name, file, key, value)
          settings_bundle = project.files.find { |f| f.path =~ /#{bundle_name}/ }

          raise "#{bundle_name} not found in project" if settings_bundle.nil?

          # The #real_path method returns the full resolved path to the Settings.bundle
          settings_bundle_path = settings_bundle.real_path

          plist_path = File.join settings_bundle_path, file

          # raises IOError
          settings_plist = File.open(plist_path) { |f| Plist.parse_xml f }

          raise "Could not parse #{plist_path}" if settings_plist.nil?

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

        def xcodeproj_path_from_params(params)
          return params[:xcodeproj] if params[:xcodeproj]

          # Adapted from commit_version_bump
          # https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/commit_version_bump.rb#L21

          # This may not be a git project. Search relative to the Gemfile.
          repo_path = Bundler.root

          all_xcodeproj_paths = Dir[File.expand_path(File.join(repo_path, '**/*.xcodeproj'))]
          # find an xcodeproj (ignoring the Cocoapods one)
          xcodeproj_paths = Fastlane::Actions.ignore_cocoapods_path(all_xcodeproj_paths)

          # no projects found: error
          UI.user_error!('Could not find a .xcodeproj in the current repository\'s working directory.') and return nil if xcodeproj_paths.count == 0

          # too many projects found: error
          if xcodeproj_paths.count > 1
            repo_pathname = Pathname.new repo_path
            relative_projects = xcodeproj_paths.map { |e| Pathname.new(e).relative_path_from(repo_pathname).to_s }.join("\n")
            UI.user_error!("Found multiple .xcodeproj projects in the current repository's working directory. Please specify your app's main project: \n#{relative_projects}")
            return nil
          end

          # one project found: great
          xcodeproj_paths.first
        end
      end
    end
  end
end
