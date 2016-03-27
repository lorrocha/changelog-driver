require 'changelog_parser'

class ChangelogDriver
  attr_accessor :ancestor, :current, :other

  # def initialize(ancestor, current, other)
  #   # ancestor = File.readlines ancestor
  #   # @file_header = parse_header ancestor
  #   #
  #   # @ancestor = parse_changelog ancestor.drop(@file_header.count)
  #   # # @current = File.readlines current
  #   # # @other = File.readlines other
  # end

  def parse_header(file)
    header = []

    file.each do |line|
      if line =~ /^[^#]/ || line[0,3].count('#') == 1
        header << line
      else
        return header
      end
    end
  end

  def parse_changelog(lines)
    descriptions = []
    sub_container = {}
    container = {}

    lines.reverse.each do |line|
      if line =~ /^[^#]/
        descriptions.unshift line
      else
        if hashes = line[0,3].count('#') == 3
          sub_container[line] = descriptions

          descriptions = []
        else
          container[line] = sub_container

          sub_container = {}
          descriptions = []
        end
      end
    end

    container
  end

end
