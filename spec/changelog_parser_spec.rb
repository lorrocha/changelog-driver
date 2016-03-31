require 'rspec'
require 'pry'
require_relative '../lib/changelog_parser'

describe ChangelogParser do
  let(:parser) { ChangelogParser.new }

  context '#parse_changelog' do
    it 'will nest descriptions and empty lines beneath the correct section' do
      array = [
        '## [Unreleased] [unreleased]',
        '### Added',
        ' - This test for one',
        '- And this line',
        "\n",
        '### Removed',
        'Something Removed'
      ]

      result = parser.parse_changelog(array)
      title = '[Unreleased] [unreleased]'
      first_subtitle = 'Added'
      second_subtitle = 'Removed'

      expect(result[title].keys).to match_array([first_subtitle, second_subtitle])
      expect(result[title][first_subtitle]).to match_array([' - This test for one', '- And this line', "\n"])
      expect(result[title][second_subtitle]).to match_array(['Something Removed'])
    end

    it 'will work when there is an empty line between the sections' do
      array = [
        '## [Unreleased] [unreleased]',
        '### Added',
        ' - This test for one',
        '## [0.3.0] - 2015-12-03',
        '### Added',
        'This was released'
      ]

      result = parser.parse_changelog(array)
      title = '[Unreleased] [unreleased]'
      second_title = '[0.3.0] - 2015-12-03'
      subtitle = 'Added'

      expect(result[title].keys).to match_array([subtitle])
      expect(result[second_title].keys).to match_array([subtitle])
      expect(result[second_title][subtitle]).to match_array(['This was released'])
    end

    it 'will work when regardless of the empty lines between the sections' do
      array = [
        '## [Unreleased] [unreleased]',
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
      title = '[Unreleased] [unreleased]'
      second_title = '[0.3.0] - 2015-12-03'
      subtitle = 'Added'

      expect(result[title].keys).to match_array([subtitle])
      expect(result[second_title].keys).to match_array([subtitle])
      expect(result[second_title][subtitle]).to match_array(['This was released'])
    end

    it 'will not include any empty lines in the parsed structure' do
      array = [
        '## [Unreleased] [unreleased]',
        '### Added',
        ' - This test for one',
        '',
        ' - This is a second one'
      ]

      result = parser.parse_changelog(array)
      title = '[Unreleased] [unreleased]'
      subtitle = 'Added'

      expect(result[title].keys).to match_array([subtitle])
      expect(result[title][subtitle]).to match_array([' - This is a second one', ' - This test for one'])
    end
  end

  context '#validate_section' do
    it 'will validate correctly if the date is "[unreleased]"' do
      string = "##[Unreleased] [unreleased]"
      expect{ parser.validate_section(string) }.to_not raise_error
    end

    it 'will validate correctly if the date in the version control is in "YYYY-MM-DD"' do
      string = "## [#.#.#] - 2016-09-20"
      expect{ parser.validate_section(string) }.to_not raise_error
    end

    it 'will raise an error if the date is in another format' do
      string = "## [#.#.#] - June 3, 2016"
      expect{ parser.validate_section(string) }.to raise_error ChangelogError
    end

    it 'will raise an error if the date is another word' do
      string = "## [#.#.#] - another thing"
      expect{ parser.validate_section(string) }.to raise_error ChangelogError
    end

    it 'will return the string without the pound signs for unreleased' do
      result = parser.validate_section("## [Unreleased] [unreleased]")
      expect(result).to eq("[Unreleased] [unreleased]")
    end

    it 'will return the string without the pound signs for a version release' do
      result = parser.validate_section("## [#.#.#] - 2016-09-20")
      expect(result).to eq("[#.#.#] - 2016-09-20")
    end
  end

  context '#validate_subsection' do
    it 'will validate correctly if the subsection is a valid entry' do
      string = "### Added"
      expect{ parser.validate_subsection(string) }.to_not raise_error
    end

    it 'will validate raise an error if the subsection is not included in the valid entries' do
      string = "### Zumba"
      expect{ parser.validate_subsection(string) }.to raise_error ChangelogError
    end

    it 'will return the string without the pound sign' do
      result = parser.validate_subsection("### Removed")
      expect(result).to eq("Removed")
    end
  end
end
