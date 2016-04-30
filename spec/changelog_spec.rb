require 'rspec'
require 'pry'
require_relative '../lib/changelog_parser'

describe Changelog do
  let(:changelog) { Changelog.new }
  let(:unreleased) {
    r = Release.new
    r.title = '[Unreleased] [unreleased]'
    r
  }
  let(:released) {
    r = Release.new
    r.title = '[0.0.13] - 2015-12-03'
    r
  }
  let(:newest_release) {
    r = Release.new
    r.title = '[0.0.15] - 2016-4-03'
    r
  }
  let(:oldest_release) {
    r = Release.new
    r.title = '[0.0.1] - 2013-4-03'
    r
  }
  let(:future_release) {
    r = Release.new
    r.title = '[11.3.1] - 2026-4-03'
    r
  }

  context '#releases' do
    it 'will return an array of releases' do
      r1 = Release.new
      r2 = Release.new

      changelog.releases << r1
      changelog.releases << r2

      expect(changelog.releases).to match_array([r1, r2])
    end
  end

  context '#unreleased' do
    context 'will return' do
      it 'the unreleased object' do
        changelog.releases << unreleased
        expect(changelog.unreleased).to eq(unreleased)
      end

      it 'if there is more than one release' do
        changelog.releases << unreleased
        changelog.releases << released

        expect(changelog.unreleased).to eq(unreleased)
      end
    end

    context 'will return' do
      it 'will return nothing if there is no unreleased objects' do
        changelog.releases << released
        expect(changelog.unreleased).to be_nil
      end
    end
  end

  context '#sorted_releases' do
    context 'will return' do
      it 'the unreleased release object first' do
        changelog.releases << unreleased
        changelog.releases << released

        expect(changelog.sorted_releases).to eq([unreleased, released])
      end

      it 'the releases sorted by most recent version after the unreleased one' do
        changelog.releases << unreleased
        changelog.releases << released
        changelog.releases << newest_release
        changelog.releases << oldest_release

        expect(changelog.sorted_releases).to \
          eq([unreleased, newest_release, released, oldest_release])

        changelog.releases << future_release

        expect(changelog.sorted_releases).to \
          eq([unreleased, future_release, newest_release, released, oldest_release])
      end

      it 'the releases sorted by most recent version date if two versions are the same' do
        changelog.releases << unreleased
        changelog.releases << released
        changelog.releases << newest_release
        changelog.releases << oldest_release
        changelog.releases << future_release

        expect(changelog.sorted_releases).to \
          eq([unreleased, future_release, newest_release, released, oldest_release])
      end
    end
  end

  context '#add_release' do
    let(:unreleased_with_added) {
      r = Release.new
      r.title = '[Unreleased] [unreleased]'
      r.added = ['added line']
      r
    }

    let(:unreleased_with_added2) {
      r = Release.new
      r.title = '[Unreleased] [unreleased]'
      r.added = ['second added line']
      r
    }

    let(:unreleased_with_changed) {
      r = Release.new
      r.title = '[Unreleased] [unreleased]'
      r.changed = ['changed line']
      r
    }

    let(:super_unreleased) {
      r = Release.new
      r.title = '[Unreleased] [unreleased]'
      r.changed = ['changed line']
      r.added = ['second added line']
      r
    }

    context 'when a release of that title doesnt already exist' do
      it 'will add the release' do
        changelog.add_release(unreleased_with_added)

        expect(changelog.unreleased.added).to eq(['added line'])
      end
    end

    context 'when a release of that title does already exist' do
      it 'will add a missing section' do
        changelog.add_release(unreleased_with_added)
        changelog.add_release(unreleased_with_changed)

        expect(changelog.unreleased.added).to eq(['added line'])
        expect(changelog.unreleased.changed).to eq(['changed line'])
      end

      it 'will add missing lines to an existing section' do
        changelog.add_release(unreleased_with_added)
        changelog.add_release(unreleased_with_added2)

        expect(changelog.unreleased.added).to \
          match_array(['added line', 'second added line'])
      end

      it 'will add both missing sections and lines to sections' do
        changelog.add_release(unreleased_with_added)
        changelog.add_release(super_unreleased)

        expect(changelog.unreleased.added).to \
          match_array(['added line', 'second added line'])
        expect(changelog.unreleased.changed).to eq(['changed line'])
      end
    end
  end

  context '#to_a' do
    it 'will return an array of all the composite releases' do
      added_lines = ['one', 'two']
      changed_line = 'I changed this'
      unreleased.add('added', added_lines)
      newest_release.add('changed', changed_line)
      released.add('changed', changed_line)

      changelog.releases = [unreleased, newest_release, released]

      array = [
        "## #{unreleased.title}",
        '### Added',
        added_lines,
        "## #{newest_release.title}",
        '### Changed',
        changed_line,
        "## #{released.title}",
        '### Changed',
        changed_line
      ].flatten

      expect(changelog.to_a).to eq(array)
    end
  end

  context '#merge' do
    it 'will return a new changelog that merges the other changelogs without altering the parents' do
      unreleased.add('added', 'my changelog')
      changelog.releases << unreleased

      second_unreleased = Release.new
      second_unreleased.title = '[Unreleased] [unreleased]'
      second_unreleased.add('added',['other changelog'])

      other_changelog = Changelog.new
      other_changelog.releases << second_unreleased

      new_changelog = changelog.merge(other_changelog)

      expect(new_changelog.unreleased.added).to eq(['other changelog', 'my changelog'])
      expect(changelog.unreleased.added).to eq(['my changelog'])
      expect(other_changelog.unreleased.added).to eq(['other changelog'])

    end
  end
end
