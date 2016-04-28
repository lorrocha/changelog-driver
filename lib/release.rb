class Release
  attr_accessor :title, :added, :changed, :deprecated, :removed, :fixed, :security

  VALID_SUBTITLES = ["added", "changed", "deprecated", "removed", "fixed", "security"]

  def sections
    VALID_SUBTITLES.select { |section|
      send(section.intern)
    }
  end
end
