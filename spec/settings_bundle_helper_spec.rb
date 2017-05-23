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

describe Fastlane::Helper::SettingsBundleHelper do
  let(:helper) { Fastlane::Helper::SettingsBundleHelper }

  describe 'formatted_value' do
    it 'replaces :version and :build' do
      settings = Fastlane::Helper::SettingsBundleHelper::Settings.new "1.0.0", "1"
      formatted_value = helper.formatted_value ":version (:build)", settings
      expect(formatted_value).to eq "1.0.0 (1)"
    end
  end

  describe 'settings_from_project' do
    it 'returns the settings from the Info.plist file' do
      # project setting
      info_plists = { "Release" => "Info.plist" }

      # mock Info.plist
      info_plist = { "CFBundleShortVersionString" => "1.0.0",
        "CFBundleVersion" => "1" }

      # mock application target
      target = double "target",
                      test_target_type?: false,
                      extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { info_plists }

      # mock project
      project = double "project", targets: [target], path: ""

      # mock out the file read
      expect(Plist).to receive(:parse_xml).with("./Info.plist") { info_plist }

      # code under test
      settings = helper.settings_from_project project, "Release", nil

      # check results
      expect(settings.build).to eq "1"
      expect(settings.version).to eq "1.0.0"
    end

    it 'finds a target by name' do
      # project setting
      info_plists = { "Release" => "Info.plist" }

      # mock Info.plist
      info_plist = { "CFBundleShortVersionString" => "1.0.0",
        "CFBundleVersion" => "1" }

      # mock targets
      test_target = double "target",
                           name: "MyAppTestTarget",
                           test_target_type?: true,
                           extension_target_type?: false
      target = double "target",
                      name: "MyAppTarget",
                      test_target_type?: false,
                      extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { info_plists }

      # mock project
      project = double "project", targets: [test_target, target], path: ""

      # mock out the file read
      expect(Plist).to receive(:parse_xml).with("./Info.plist") { info_plist }

      # code under test
      settings = helper.settings_from_project project, "Release", "MyAppTarget"

      # check results
      expect(settings.build).to eq "1"
      expect(settings.version).to eq "1.0.0"
    end

    it 'raises if no target specified and application target found' do
      test_target = double "target",
                           test_target_type?: true,
                           extension_target_type?: false

      extension_target = double "target",
                                test_target_type?: false,
                                extension_target_type?: true

      project = double "project", targets: [test_target, extension_target]

      expect do
        helper.settings_from_project project, "Release", nil
      end.to raise_error RuntimeError
    end

    it 'raises if target specified and not found' do
      application_target = double "target",
                                  name: "ATarget",
                                  test_target_type?: false,
                                  extension_target_type?: false

      project = double "project", targets: [application_target]
      expect do
        helper.settings_from_project project, "Release", "MyAppTarget"
      end.to raise_error RuntimeError
    end

    it 'raises if INFOPLIST_FILE not found' do
      # mock application target
      target = double "target",
                      test_target_type?: false,
                      extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { nil }

      # mock project
      project = double "project", targets: [target], path: ""

      expect do
        helper.settings_from_project project, "Release", nil
      end.to raise_error RuntimeError
    end

    it 'raises if no Info.plist for the specified configuration' do
      # mock application target
      target = double "target",
                      test_target_type?: false,
                      extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { { "Debug" => "Info.plist" } }

      # mock project
      project = double "project", targets: [target], path: ""

      expect do
        helper.settings_from_project project, "Release", nil
      end.to raise_error RuntimeError
    end

    it 'raises if Info.plist cannot be opened' do
      # mock application target
      target = double "target",
                      test_target_type?: false,
                      extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { { "Release" => "Info.plist" } }

      # mock project
      project = double "project", targets: [target], path: ""

      expect(Plist).to receive(:parse_xml) { nil }

      expect do
        helper.settings_from_project project, "Release", nil
      end.to raise_error RuntimeError
    end

    it 'raises if no marketing version in Info.plist' do
      # project setting
      info_plists = { "Release" => "Info.plist" }

      # mock Info.plist
      info_plist = { "CFBundleVersion" => "1" }

      # mock application target
      target = double "target",
                      test_target_type?: false,
                      extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { info_plists }

      # mock project
      project = double "project", targets: [target], path: ""

      # mock out the file read
      expect(Plist).to receive(:parse_xml).with("./Info.plist") { info_plist }

      # code under test
      expect do
        helper.settings_from_project project, "Release", nil
      end.to raise_error RuntimeError
    end

    it 'raises if no build number in Info.plist' do
      # project setting
      info_plists = { "Release" => "Info.plist" }

      # mock Info.plist
      info_plist = { "CFBundleShortVersionString" => "1" }

      # mock application target
      target = double "target",
                      test_target_type?: false,
                      extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { info_plists }

      # mock project
      project = double "project", targets: [target], path: ""

      # mock out the file read
      expect(Plist).to receive(:parse_xml).with("./Info.plist") { info_plist }

      # code under test
      expect do
        helper.settings_from_project project, "Release", nil
      end.to raise_error RuntimeError
    end
  end

  describe 'update_settings_plist_title_setting' do
    it 'updates the Settings.bundle as specified' do
      # Contents of Root.plist
      preferences = {
        "PreferenceSpecifiers" => [
          {
            "Type" => "PSTitleValueSpecifier",
            "Key" => "CurrentAppVersion"
          }
        ]
      }

      # mock file
      settings_bundle = double "file", path: "Settings.bundle"

      # mock project
      project = double "project",
                       files: [settings_bundle],
                       path: "/a/b/c/MyProject.xcodeproj"

      # mock out the file read
      expect(Plist).to receive(:parse_xml) { preferences }

      # and write
      expect(Plist::Emit).to receive(:save_plist)

      # code under test
      helper.update_settings_plist_title_setting project, "Root.plist",
                                                 "CurrentAppVersion", "1.0.0 (1)"
    end

    it 'raises if no Settings.bundle in project' do
      project = double "project", files: []

      expect do
        helper.update_settings_plist_title_setting project, "Root.plist",
                                                   "CurrentAppVersion", "1.0.0 (1)"
      end.to raise_error RuntimeError
    end

    it 'raises if the settings plist file cannot be opened' do
      # mock file
      settings_bundle = double "file", path: "Settings.bundle"

      # mock project
      project = double "project",
                       files: [settings_bundle],
                       path: "/a/b/c/MyProject.xcodeproj"

      # mock nil return
      expect(Plist).to receive(:parse_xml) { nil }

      expect do
        helper.update_settings_plist_title_setting project, "Root.plist",
                                                   "CurrentAppVersion", "1.0.0 (1)"
      end.to raise_error RuntimeError
    end

    it 'raises if PreferenceSpecifiers not found in plist' do
      # mock file
      settings_bundle = double "file", path: "Settings.bundle"

      # mock project
      project = double "project",
                       files: [settings_bundle],
                       path: "/a/b/c/MyProject.xcodeproj"

      # mock out the file read
      expect(Plist).to receive(:parse_xml) { {} }

      expect do
        helper.update_settings_plist_title_setting project, "Root.plist",
                                                   "CurrentAppVersion", "1.0.0 (1)"
      end.to raise_error RuntimeError
    end

    it 'raises if specified key not found' do
      # Contents of Root.plist
      preferences = { "PreferenceSpecifiers" => [] }

      # mock file
      settings_bundle = double "file", path: "Settings.bundle"

      # mock project
      project = double "project",
                       files: [settings_bundle],
                       path: "/a/b/c/MyProject.xcodeproj"

      # mock out the file read
      expect(Plist).to receive(:parse_xml) { preferences }

      expect do
        helper.update_settings_plist_title_setting project, "Root.plist",
                                                   "CurrentAppVersion", "1.0.0 (1)"
      end.to raise_error RuntimeError
    end

    it 'raises if specified key is not a Title' do
      # Contents of Root.plist
      preferences = {
        "PreferenceSpecifiers" => [
          {
            "Type" => "PSToggleSwitchSpecifier",
            "Key" => "CurrentAppVersion"
          }
        ]
      }

      # mock file
      settings_bundle = double "file", path: "Settings.bundle"

      # mock project
      project = double "project",
                       files: [settings_bundle],
                       path: "/a/b/c/MyProject.xcodeproj"

      # mock out the file read
      expect(Plist).to receive(:parse_xml) { preferences }

      expect do
        helper.update_settings_plist_title_setting project, "Root.plist",
                                                   "CurrentAppVersion", "1.0.0 (1)"
      end.to raise_error RuntimeError
    end
  end
end
