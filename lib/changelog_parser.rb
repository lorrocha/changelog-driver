require_relative 'changelog_error'

class ChangelogParser
  VALID_SUBTITLES = ["Added", "Changed", "Deprecated", "Removed", "Fixed", "Security"]

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

  def parse_changelog(file)
    descriptions = []
    subcontainer = {}
    container = {}

    file.reverse.each do |line|
      if /^[^#]*$/ =~ line
        descriptions.unshift line unless line.empty?
      else
        hashes = line[0,5].count('#')
        if hashes == 2
          line = validate_section line

          container[line] = subcontainer
          subcontainer = {}
          descriptions = []
        elsif hashes == 3
          line = validate_subsection line

          subcontainer[line] = descriptions
          descriptions = []
        else
          raise ChangelogError, 'Incorrect Changelog Format: titles can only have 2 or 3 hashes.'
        end
      end
    end

    container
  end

  def validate_section(line)
    line = strip_hashes line

    /^(?<version>.+\])[- ]{1,3}(?<date>.+)/ =~ line

    Date.strptime(date, '%Y-%m-%d') unless date.downcase == '[unreleased]'

    line
  rescue
    raise ChangelogError, "Invalid Section Title: Correct Format is '[#.#.#] - YYYY-MM-DD' or '[Unreleased] [unreleased]'"
  end

  def validate_subsection(line)
    line = strip_hashes line

    unless VALID_SUBTITLES.include? line
      raise ChangelogError, "Invalid Subsection Title: Must be one of: " + VALID_SUBTITLES.join(', ')
    end

    line
  end

  private
  def strip_hashes(line)
    line.gsub(/^[#]{1,3} /,'')
  end
end
