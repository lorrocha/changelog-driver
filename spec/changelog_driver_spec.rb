require 'rspec'
require 'pry'
require_relative '../lib/changelog_driver'

describe ChangelogDriver do
  context '#merge' do
    it 'in a larger base case' do
      base_file = "spec/files/larger-test"
      finished = File.read("#{base_file}.finished").split("\n") << ''

      new_changelog = ChangelogDriver.new("#{base_file}.base", "#{base_file}.my", "#{base_file}.other").merge

      expect(finished).to eq(new_changelog.to_a)
    end

    it 'in a the correct order' do
      base_file = "spec/files/reorder-test"
      finished = File.read("#{base_file}.finished").split("\n") << ''

      new_changelog = ChangelogDriver.new("#{base_file}.base", "#{base_file}.my", "#{base_file}.other").merge

      expect(finished).to eq(new_changelog.to_a)
    end

  end
end
