require 'rspec'
require 'pry'
require_relative '../lib/changelog_driver'

describe ChangelogDriver do
  context '#merge' do
    it 'in the basic case' do
      base_file = "spec/files/simple-test"
      finished = File.read("#{base_file}.finished").split("\n") << ''

      new_changelog = ChangelogDriver.new("#{base_file}.base", "#{base_file}.my", "#{base_file}.other").compose_changelog

      expect(finished).to eq(new_changelog.to_a)
    end

    it 'in a larger base case' do
      base_file = "spec/files/larger-test"
      finished = File.read("#{base_file}.finished").split("\n") << ''

      new_changelog = ChangelogDriver.new("#{base_file}.base", "#{base_file}.my", "#{base_file}.other").compose_changelog

      expect(finished).to eq(new_changelog.to_a)
    end

    it 'in a the correct order' do
      base_file = "spec/files/reorder-test"
      finished = File.read("#{base_file}.finished").split("\n") << ''

      new_changelog = ChangelogDriver.new("#{base_file}.base", "#{base_file}.my", "#{base_file}.other").compose_changelog

      expect(finished).to eq(new_changelog.to_a)
    end

    it 'will remove a line from unreleased if it was released in one of the merges' do
      base_file = "spec/files/remove-from-unreleased"
      finished = File.read("#{base_file}.finished").split("\n") << ''

      new_changelog = ChangelogDriver.new("#{base_file}.base", "#{base_file}.my", "#{base_file}.other").compose_changelog

      expect(finished).to eq(new_changelog.to_a)
    end
  end
end
