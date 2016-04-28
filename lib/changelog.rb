class Changelog
  attr_accessor :releases

  def initialize
    @releases = []
  end

  def unreleased
    releases.detect { |r| /[Uu]nreleased/ =~ r.title }
  end

  def sorted_releases
    released = releases - [unreleased]

    [unreleased] | released.sort_by { |r|
      /\A\[(?<version>.+)\] - (?<date>.+)/ =~ r.title

      # sort by version, but in worst case scenario, include date sorting
      version.split('.').map(&:to_i) | [date.split('-')]
    }.reverse
  end
end
