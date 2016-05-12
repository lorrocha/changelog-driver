class Release
  attr_accessor :title, :added, :changed, :removed, :fixed, :deprecated, :security

  VALID_SUBTITLES = ["added", "changed", "removed", "fixed", "deprecated", "security"]

  def sections
    VALID_SUBTITLES.select { |section|
      get section
    }
  end

  def add(section, item)
    replace_section section, (Array(get section) | Array(item))
  end

  def remove(section, item)
    replace_section section, (Array(get section) - Array(item))
  end

  def get(section)
    send(section.intern)
  end

  def to_a
    all_sections = sections.flat_map { |section|
      get(section).unshift(decorated_section(section))
    }

    all_sections.unshift(decorated_title)
  end

  def decorated_title
    "## #{title}"
  end

  def decorated_section(name)
    "### #{name.capitalize}"
  end

  def unreleased?
    /[Uu]nreleased/ =~ title
  end

  private
  def replace_section(section, replacement)
    send "#{section}=", replacement
  end
end
