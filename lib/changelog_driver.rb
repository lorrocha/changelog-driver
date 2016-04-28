require 'changelog_parser'
require 'changelog_error'
require 'changelog'
require 'section'

class ChangelogDriver
  attr_accessor :ancestor, :current, :other, :header

  def initialize(ancestor, current, other)
    # need to determine the header to apply to the changelog off of one of these guys
    ancestor_file = file_lines(ancestor)
    determine_header(ancestor_file)

    @ancestor = parse(ancestor_file)
    @current = parse(file_lines(current))
    @other = parse(file_lines(other))
  end

  def merge
    composite_changelog = header
    binding.pry
  end

  def ordered_sections
    #start with unreleased, then move to the others in version/date order
    all_versions = ancestor.keys | current.keys | other.keys

    unreleased = all_versions.select { |v| v =~ /[Uu]nreleased/ }
    other_versions = (all_versions - unreleased).sort { |v|
      /\A\[(?<version>.+)\]/ =~ v

      version.split('.').map(&:to_i)
    }

    unreleased + other_versions
  end

  private
  def determine_header(lines)
    heading_lines = []

    lines.each do |line|
      break if line =~ /^\#{2}/
      heading_lines << line
    end
    @header = heading_lines
  end

  def file_lines(path)
    File.read(path).split("\n")
  end

  def parse(lines)
    @parser ||= ChangelogParser.new

    @parser.parse_changelog( lines - header )
  end
end
