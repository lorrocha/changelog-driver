require 'rspec'
require 'pry'
require_relative '../lib/changelog_parser'

describe ChangelogParser do
  let(:parser) { ChangelogParser.new }

  context 'parse_changelog' do
    it 'will nest descriptions and empty lines beneath the correct section' do
      array = [
        '## [Unreleased]',
        '### Added',
        ' - This test for one',
        '- And this line',
        "\n",
        '### Removed',
        'Something Removed'
      ]

      title = '[Unreleased]'
      first_subtitle = 'Added'
      second_subtitle = 'Removed'

      result = parser.parse_changelog(array)

      expect(result[title].keys).to match_array([first_subtitle, second_subtitle])
      expect(result[title][first_subtitle]).to match_array([' - This test for one', '- And this line', "\n"])
      expect(result[title][second_subtitle]).to match_array(['Something Removed'])
    end

    it 'will work when there is an empty line between the sections' do
      array = [
        '## [Unreleased]',
        '### Added',
        ' - This test for one',
        '## [0.3.0] - 2015-12-03',
        '### Added',
        'This was released'
      ]

      result = parser.parse_changelog(array)

      title = '[Unreleased]'
      second_title = '[0.3.0] - 2015-12-03'
      subtitle = 'Added'

      expect(result[title].keys).to match_array([subtitle])
      expect(result[second_title].keys).to match_array([subtitle])
      expect(result[second_title][subtitle]).to match_array(['This was released'])
    end

    it 'will work when regardless of the empty lines between the sections' do
      array = [
        '## [Unreleased]',
        "\n",
        '### Added',
        ' - This test for one',
        '## [0.3.0] - 2015-12-03',
        "\n",
        "\n",
        '### Added',
        'This was released'
      ]

      result = parser.parse_changelog(array)

      title = '[Unreleased]'
      second_title = '[0.3.0] - 2015-12-03'
      subtitle = 'Added'

      expect(result[title].keys).to match_array([subtitle])
      expect(result[second_title].keys).to match_array([subtitle])
      expect(result[second_title][subtitle]).to match_array(['This was released'])
    end
  end
end
