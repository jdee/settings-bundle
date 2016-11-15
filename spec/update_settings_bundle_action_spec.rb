describe Fastlane::Actions::UpdateSettingsBundleAction do
  let (:action) { Fastlane::Actions::UpdateSettingsBundleAction }

  describe '#run' do
    it 'calls the appropriate helper methods' do
      project = double "project"
      expect(Xcodeproj::Project).to receive(:open).with("MyProject.xcodeproj") { project }

      helper = Fastlane::Helper::SettingsBundleHelper
      expect(helper).to receive(:formatted_version_from_info_plist).with(project, "Release") { "1.0.0 (1)" }

      expect(helper).to receive(:update_settings_plist_title_setting)
        .with project, "Root.plist", "CurrentAppVersion", "1.0.0 (1)"

      action.run xcodeproj: "MyProject.xcodeproj", key: "CurrentAppVersion",
        configuration: "Release", file: "Root.plist"
    end
  end
end
