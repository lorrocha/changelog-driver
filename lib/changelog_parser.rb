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
      if line =~ /^[^#]/
        descriptions.unshift line
      else
        hashes = line[0,5].count('#')

        if hashes == 2
          line = validate_section line
          container[line] = sub_container

          subcontainer = {}
          descriptions = []
        elsif hashes == 3
          line = validate_subsection line

          subcontainer[line] = descriptions
          descriptions = []
        else
          raise "Incorrect Changelog Format"
        end
      end
    end

    container
  end

  def validate_section(line)
    line = strip_hashes line
    binding.pry
  end

  def validate_subsection(line)
    line.
  end

  private
  def strip_hashes(line)
    first_half.gsub(/^#{1,3}/,'')
  end
end
