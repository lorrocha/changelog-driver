require 'changelog_driver/changelog_parser'
require 'changelog_driver/changelog_error'
require 'changelog_driver/changelog_transcriber'
require 'changelog_driver/changelog'
require 'changelog_driver/release'

class ChangelogDriver
  attr_accessor :ancestor, :current, :other, :header

  def initialize(ancestor, current, other)
    @current_path = current
    @ancestor = parse(file_lines(ancestor))
    @current = parse(file_lines(current))
    @other = parse(file_lines(other))
  end

  def compose_changelog
    @composed_changelog ||= current.merge(other)
  end

  def merge
    ct = ChangelogTranscriber.new(compose_changelog)

    ct.write_to @current_path
  end

  private
  def file_lines(path)
    File.read(path).split("\n")
  end

  def parse(lines)
    @parser ||= ChangelogParser.new

    @parser.parse_changelog(lines)
  end
end
