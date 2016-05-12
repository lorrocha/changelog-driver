Gem::Specification.new do |s|
  s.name        = 'changelog-driver'
  s.version     = '0.0.0'
  s.date        = '2016-05-12'
  s.summary     = "A custom git merge strategy for changelogs"
  s.description = "A custom git merge strategy for changelogs"
  s.authors     = ["Lorrayne Rocha", "Chris Houhoulis"]
  s.email       = 'lorrocha90@gmail.com'
  s.files       = ["lib/changelog_driver.rb", "lib/changelog_driver/changelog_error.rb",
    "lib/changelog_driver/changelog_parser.rb", "lib/changelog_driver/changelog_transcriber.rb",
    "lib/changelog_driver/changelog.rb", "lib/changelog_driver/release.rb"]
  s.homepage    =
    'http://rubygems.org/gems/changelog_driver'
  s.license       = 'MIT'
  s.executables << 'merge-into-changelog'
end
