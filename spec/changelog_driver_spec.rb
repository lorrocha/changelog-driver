require 'rspec'
require 'pry'
require_relative '../lib/changelog_driver'

describe ChangelogDriver do
  it 'first' do
    base_file = "spec/files/larger-test"

    cd = ChangelogDriver.new("#{base_file}.base", "#{base_file}.my", "#{base_file}.other").merge

    new_changelog = cd.merge
  end

end
