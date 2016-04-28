class Release
  attr_accessor :title, :added, :changed, :deprecated, :removed, :fixed, :security

  VALID_SUBTITLES = ["added", "changed", "deprecated", "removed", "fixed", "security"]

  def sections
    VALID_SUBTITLES.select { |section|
      send(section.intern)
    }
  end

  def add(section, item)
    current_objects = send(section.intern)
    send "#{section}=", (Array(current_objects) | Array(item))
  end
end
