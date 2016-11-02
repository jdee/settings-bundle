describe Fastlane::Actions::SettingsBundleAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The settings_bundle plugin is working!")

      Fastlane::Actions::SettingsBundleAction.run(nil)
    end
  end
end
