require 'plist'

describe Fastlane::Helper::SettingsBundleHelper do
  let(:helper) { Fastlane::Helper::SettingsBundleHelper }

  describe 'formatted_version_from_info_plist' do
    it 'returns the formatted version from the Info.plist file' do
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
      project = double "project", targets: [ target ], path: ""

      # mock out the file read
      expect(Plist).to receive(:parse_xml).with("./Info.plist") { info_plist }

      # code under test
      formatted_string = helper.formatted_version_from_info_plist project, "Release"

      # check results
      expect(formatted_string).to eq "1.0.0 (1)"
    end

    it 'raises if no application target found' do
      test_target = double "target",
        test_target_type?: true,
        extension_target_type?: false

      extension_target = double "target",
        test_target_type?: false,
        extension_target_type?: true

      project = double "project", targets: [ test_target, extension_target ]

      expect {
        helper.formatted_version_from_info_plist project, "Release"
      }.to raise_error RuntimeError
    end

    it 'raises if INFOPLIST_FILE not found' do
      # mock application target
      target = double "target",
        test_target_type?: false,
        extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { nil }

      # mock project
      project = double "project", targets: [ target ], path: ""

      expect {
        helper.formatted_version_from_info_plist project, "Release"
      }.to raise_error RuntimeError
    end

    it 'raises if no Info.plist for the specified configuration' do
      # mock application target
      target = double "target",
        test_target_type?: false,
        extension_target_type?: false

      expect(target).to receive(:resolved_build_setting)
        .with("INFOPLIST_FILE") { { "Debug" => "Info.plist" } }

      # mock project
      project = double "project", targets: [ target ], path: ""

      expect {
        helper.formatted_version_from_info_plist project, "Release"
      }.to raise_error RuntimeError
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
      project = double "project", targets: [ target ], path: ""

      # mock out the file read
      expect(Plist).to receive(:parse_xml).with("./Info.plist") { info_plist }

      # code under test
      expect {
        helper.formatted_version_from_info_plist project, "Release"
      }.to raise_error RuntimeError
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
      project = double "project", targets: [ target ], path: ""

      # mock out the file read
      expect(Plist).to receive(:parse_xml).with("./Info.plist") { info_plist }

      # code under test
      expect {
        helper.formatted_version_from_info_plist project, "Release"
      }.to raise_error RuntimeError
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
        files: [ settings_bundle ],
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

      expect {
        helper.update_settings_plist_title_setting project, "Root.plist",
          "CurrentAppVersion", "1.0.0 (1)"
      }.to raise_error RuntimeError
    end

    it 'raises if PreferenceSpecifiers not found in plist' do
      # mock file
      settings_bundle = double "file", path: "Settings.bundle"

      # mock project
      project = double "project",
        files: [ settings_bundle ],
        path: "/a/b/c/MyProject.xcodeproj"

      # mock out the file read
      expect(Plist).to receive(:parse_xml) { {} }

      expect {
        helper.update_settings_plist_title_setting project, "Root.plist",
          "CurrentAppVersion", "1.0.0 (1)"
      }.to raise_error RuntimeError
    end

    it 'raises if specified key not found' do
      # Contents of Root.plist
      preferences = { "PreferenceSpecifiers" => [ ] }

      # mock file
      settings_bundle = double "file", path: "Settings.bundle"

      # mock project
      project = double "project",
        files: [ settings_bundle ],
        path: "/a/b/c/MyProject.xcodeproj"

      # mock out the file read
      expect(Plist).to receive(:parse_xml) { preferences }

      expect {
        helper.update_settings_plist_title_setting project, "Root.plist",
          "CurrentAppVersion", "1.0.0 (1)"
      }.to raise_error RuntimeError
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
        files: [ settings_bundle ],
        path: "/a/b/c/MyProject.xcodeproj"

      # mock out the file read
      expect(Plist).to receive(:parse_xml) { preferences }

      expect {
        helper.update_settings_plist_title_setting project, "Root.plist",
          "CurrentAppVersion", "1.0.0 (1)"
      }.to raise_error RuntimeError
    end
  end
end
