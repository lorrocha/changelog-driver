class Release
  attr_accessor :title, :added, :changed, :removed, :fixed, :deprecated, :security

  VALID_SUBTITLES = ["added", "changed", "removed", "fixed", "deprecated", "security"]

  def sections
    VALID_SUBTITLES.select { |section|
      send(section.intern)
    }
  end

  def add(section, item)
    send "#{section}=", (Array(get section) | Array(item))
  end

  def get(section)
    send(section.intern)
  end
end
