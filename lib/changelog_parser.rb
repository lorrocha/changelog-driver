require_relative 'changelog_error'
require 'changelog'
require 'release'

class ChangelogParser
  def parse_changelog(file)
    descriptions = []
    release = Release.new
    changelog = Changelog.new

    header, file = determine_header_for(file)
    changelog.prefix = header

    file.reverse.each do |line|
      if /^[^#]*$/ =~ line
        descriptions.unshift line unless line.empty?
      else
        hashes = line[0,5].count('#')
        if hashes == 2
          release.title = validate_release_title(line)
          changelog.releases << release

          release = Release.new
          descriptions = []
        elsif hashes == 3
          release_subtitle = validate_subsection line
          release.add(release_subtitle, descriptions)

          descriptions = []
        else
          raise ChangelogError, 'Incorrect Changelog Format: titles can only have 2 or 3 hashes.'
        end
      end
    end

    changelog
  end

  def determine_header_for(lines)
    part_of_header = true

    lines.partition { |line|
      if /^##/ =~ line
        part_of_header = false
      end
      part_of_header
    }
  end

  def validate_release_title(line)
    strip_hashes(line).tap { |line|
      /^\[(?<version>.+)\][- ]{0,3}(?<date>.+)/ =~ line

      Date.strptime(date, '%Y-%m-%d') unless date.downcase == '[unreleased]'
    }
  rescue
    raise ChangelogError, "Invalid Section Title: Correct Format is '[#.#.#] - YYYY-MM-DD' or '[Unreleased] [unreleased]'"
  end

  def validate_subsection(line)
    strip_hashes(line).downcase.tap { |line|
      unless Release::VALID_SUBTITLES.include? line
        raise ChangelogError, "Invalid Subsection Title: Must be one of: " + Release::VALID_SUBTITLES.join(', ')
      end
    }
  end

  private
  def strip_hashes(line)
    line.gsub(/^[#]{1,3}[ ]?/,'')
  end
end
