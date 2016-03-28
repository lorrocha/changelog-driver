require 'changelog_parser'
require 'changelog_error'

class ChangelogDriver
  attr_accessor :ancestor, :current, :other

  def initialize(ancestor, current, other)
    parser = ChangelogParser.new
  end
end
