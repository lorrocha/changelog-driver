require 'rspec'
require 'pry'
require 'fileutils'
require_relative '../lib/changelog_driver'

describe ChangelogTranscriber do
  TMP_DIR = 'spec/tmp'

  let(:release) { r = Release.new
    r.title = '[Unreleased] [unreleased]'
    r.add('added', ['first', 'second'])
    r
  }

  let(:release2) { r = Release.new
    r.title = '[1.9.9] - 2016-09-20'
    r.add('added', ['first', 'second'])
    r.add('changed', ['first changed line', 'second changed line'])
    r
  }

  let(:changelog) { c = Changelog.new
    c.prefix = ['Blah blah blah', 'this is a changelog thing', '']
    c.releases = [release, release2]
    c
  }

  before :all do
    if Dir.exists?(TMP_DIR)
      FileUtils.rm_rf("#{TMP_DIR}/.", secure: true)
    else
      FileUtils.mkdir(TMP_DIR)
    end
  end

  after :all do
    FileUtils.rm_rf("#{TMP_DIR}/.", secure: true)
  end

  context '#write_to' do
    it 'will write to a file' do
      new_file = "#{TMP_DIR}/test1.md"

      transcriber = ChangelogTranscriber.new(changelog)
      transcriber.write_to new_file

      file_lines = File.read(new_file)

      expectation = "Blah blah blah\nthis is a changelog thing\n\n" +
        "## [Unreleased] [unreleased]\n### Added\nfirst\nsecond\n\n" +
        "## [1.9.9] - 2016-09-20\n### Added\nfirst\nsecond\n" +
        "### Changed\nfirst changed line\nsecond changed line\n"

      expect(expectation).to eq(file_lines)
    end
  end
end
