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

describe Fastlane::Actions::UpdateSettingsBundleAction do
  let (:action) { Fastlane::Actions::UpdateSettingsBundleAction }

  describe '#run' do
    it 'calls the appropriate helper methods' do
      project = double "project"
      expect(Xcodeproj::Project).to receive(:open).with("MyProject.xcodeproj") { project }

      settings = Fastlane::Helper::SettingsBundleHelper::Settings.new "1.0.0", "1"

      helper = Fastlane::Helper::SettingsBundleHelper
      expect(helper).to receive(:settings_from_project).with(project, "Release", "MyAppTarget") { settings }
      expect(helper).to receive(:formatted_value).with(":version (:build)", settings) { "1.0.0 (1)" }

      expect(helper).to receive(:update_settings_plist_title_setting)
        .with project, "Root.plist", "CurrentAppVersion", "1.0.0 (1)"

      action.run xcodeproj: "MyProject.xcodeproj", key: "CurrentAppVersion",
        configuration: "Release", file: "Root.plist",
        value: ":version (:build)", target: "MyAppTarget"
    end

    it 'logs on error' do
      expect(Xcodeproj::Project).to receive(:open).and_raise "Not found"

      expect(FastlaneCore::UI).to receive(:user_error!).with "Not found"

      action.run xcodeproj: "MyProject.xcodeproj"
    end
  end

  describe 'OS support' do
    it 'is supported on iOS' do
      expect(action.is_supported?(:ios)).to be true
    end
  end

  describe 'category' do
    it 'is in the :project category' do
      expect(action.category).to eq(:project)
    end
  end

  describe 'options' do
    let(:options) { action.available_options }

    it 'has the right number of options' do
      # reminder to add tests for any new options
      expect(options.count).to equal(6)
    end

    it 'includes a :xcodeproj option' do
      expect(options.find { |o| o.key == :xcodeproj && o.env_name == "SETTINGS_BUNDLE_XCODEPROJ" }).not_to be_nil
    end

    it 'includes a :key option' do
      expect(options.find { |o| o.key == :key && o.env_name == "SETTINGS_BUNDLE_KEY" }).not_to be_nil
    end

    it 'includes a :value option' do
      expect(options.find { |o| o.key == :value && o.env_name == "SETTINGS_BUNDLE_VALUE" }).not_to be_nil
    end

    it 'includes a :configuration option' do
      expect(options.find { |o| o.key == :configuration && o.env_name == "SETTINGS_BUNDLE_CONFIGURATION" }).not_to be_nil
    end

    it 'includes a :file option' do
      expect(options.find { |o| o.key == :file && o.env_name == "SETTINGS_BUNDLE_FILE" }).not_to be_nil
    end

    it 'includes a :target option' do
      expect(options.find { |o| o.key == :target && o.env_name == "SETTINGS_BUNDLE_TARGET" }).not_to be_nil
    end
  end

  # Satisfy simplecov
  describe 'other methods' do
    it 'has examples' do
      expect(action.example_code).not_to be nil
    end

    it 'has options' do
      expect(action.available_options).not_to be nil
    end

    it 'has details' do
      expect(action.details).not_to be nil
    end

    it 'has an author' do
      expect(action.author).not_to be nil
    end

    it 'has a description' do
      expect(action.description).not_to be nil
    end
  end
end
