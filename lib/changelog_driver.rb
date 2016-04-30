require 'changelog_parser'
require 'changelog_error'
require 'changelog'
require 'section'

class ChangelogDriver
  attr_accessor :ancestor, :current, :other, :header

  def initialize(ancestor, current, other)
    @ancestor = parse(file_lines(ancestor))
    @current = parse(file_lines(current))
    @other = parse(file_lines(other))
  end

  def changelog
    current.merge(other)
  end

  private
  def file_lines(path)
    File.read(path).split("\n")
  end

  def parse(lines)
    @parser ||= ChangelogParser.new

    @parser.parse_changelog( lines - header )
  end
end
