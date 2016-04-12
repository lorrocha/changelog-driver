class Changelog
  @releases

  def unreleased
    @releases.where(version == "Unreleased")
    # OR
    parser populates unreleased directly
  end

  def releases
    @releases
  end

  def versions
    @releases.map &:version

  def most_recent_version_number
    first not-unreleased release, pluck out the version
  end
end

class Release
  def version
    string
  end
  def added, changed, ...
    maybe [lines]
    maybe a section object
  end
end

class Section
  def contents
    [lines]
  end
end
