require 'rspec'
require 'pry'
require_relative '../lib/changelog_parser'

describe Release do
  let(:release) { Release.new }

  context '#sections' do
    it 'will only return sections that have content in them' do
      release.added = ['things']
      release.changed = ['yooo']

      expect(release.sections).to match_array(['added', 'changed'])
    end

    it 'will return an empty array if no sections have content' do
      expect(release.sections).to eq([])
    end
  end

  context '#add' do
    context 'will add an item' do
      it 'to a section if its a string' do
        string = 'string to add'
        release.add('added', string)

        expect(release.added).to match_array([string])
      end

      it 'to a section if its an array' do
        array = [1,2,3]
        release.add('added', array)

        expect(release.added).to match_array(array)
      end

      it 'to a section that already has things in it' do
        release.added = [1,2]
        release.add('added', [2,3])

        expect(release.added).to match_array([1,2,3])
      end
    end

    context 'will not add an item' do
      it 'if it has already been added' do
        string = "String"
        release.add('added', string)

        expect(release.added).to match_array([string])
        release.add('added', string)

        expect(release.added).to match_array([string])
      end
    end
  end

  context '#get' do
    it 'will return the contents of a section if you give it a string' do
      release.add('added', 'hey I just added this guy')

      expect(release.added).to eq(release.get('added'))
      release.add('added', 'this is a second string')

      expect(release.added).to eq(release.get('added'))
    end
  end

  context '#to_a' do
    context 'will return an array' do
      it 'of all the lines' do
        release.title = "Some title"
        release.add('added', "some line")
        array = ['## Some title', '### Added', 'some line']

        expect(release.to_a).to eq(array)
      end

      it 'if it has multiple sections as well' do
        release.title = "Some title"
        release.add('added', "some line")
        release.add('changed', ['one', 'two'])
        array = ['## Some title', '### Added', 'some line',
          '### Changed', 'one', 'two']

        expect(release.to_a).to eq(array)
      end
    end
  end
end
