require 'changelog_parser'

class ChangelogDriver
  attr_accessor :ancestor, :current, :other

  def initialize(ancestor, current, other)
    parser = ChangelogParser.new
  end
end
