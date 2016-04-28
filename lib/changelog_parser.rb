require_relative 'changelog_error'
require 'changelog'
require 'release'

class ChangelogParser
  def parse_changelog(file)
    descriptions = []
    release = Release.new
    changelog = Changelog.new

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

          release.send("#{release_subtitle}=".intern, descriptions)
          descriptions = []
        else
          raise ChangelogError, 'Incorrect Changelog Format: titles can only have 2 or 3 hashes.'
        end
      end
    end

    changelog
  end

  def validate_release_title(line)
    line = strip_hashes line

    /^(?<version>.+\])[- ]{1,3}(?<date>.+)/ =~ line

    Date.strptime(date, '%Y-%m-%d') unless date.downcase == '[unreleased]'

    line
  rescue
    raise ChangelogError, "Invalid Section Title: Correct Format is '[#.#.#] - YYYY-MM-DD' or '[Unreleased] [unreleased]'"
  end

  def validate_subsection(line)
    line = strip_hashes(line).downcase

    unless Release::VALID_SUBTITLES.include? line
      raise ChangelogError, "Invalid Subsection Title: Must be one of: " + Release::VALID_SUBTITLES.join(', ')
    end

    line
  end

  private
  def strip_hashes(line)
    line.gsub(/^[#]{1,3} /,'')
  end
end
