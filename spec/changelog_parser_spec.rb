require 'rspec'
require 'pry'
require_relative '../lib/changelog_parser'

describe ChangelogParser do
  let(:parser) { ChangelogParser.new }

  context 'parse_changelog' do
    it 'will nest descriptions and empty lines beneath the correct section' do
      title = '## Title thing'
      first_subtitle = '### First Subtitle'
      second_subtitle = '### Second Subtitle'
      array = [
        title,
        first_subtitle,
        " - Description",
        "Desc",
        "\n",
        second_subtitle,
        'Another desc'
      ]

      result = parser.parse_changelog(array)

      expect(result[title].keys).to match_array([first_subtitle, second_subtitle])
      expect(result[title][first_subtitle]).to match_array([' - Description', 'Desc', "\n"])
      expect(result[title][second_subtitle]).to match_array(['Another desc'])
    end

    # it 'will work when there is an empty line between the sections' do
    #   title = '## First'
    #   second_title = '## Second'
    #   first_subtitle = '### First Sub'
    #   second_subtitle = '### Second Sub'
    #   array = [
    #     title,
    #     "\n",
    #     first_subtitle,
    #     "Desc 1",
    #     "\n",
    #     second_title,
    #     "\n",
    #     second_subtitle,
    #     "Desc 2"
    #   ]
    #
    #   result = parser.parse_changelog(array)
    #
    #   expect(result[title].keys).to match_array([first_subtitle])
    #   expect(result[second_title].keys).to match_array(second_subtitle)
    # end
    #
    # it 'will work when regardless of the empty lines between the sections' do
    #   title = '## First'
    #   first_subtitle = '### First Sub'
    #   array = [
    #     title,
    #     "\n",
    #     "\n",
    #     first_subtitle,
    #     "Desc 1",
    #     "\n",
    #   ]
    #
    #   result = parser.parse_changelog(array)
    #
    #   expect(result[title].keys).to match_array([first_subtitle])
    # end
  end
end
