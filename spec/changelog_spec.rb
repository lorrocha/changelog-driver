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
end