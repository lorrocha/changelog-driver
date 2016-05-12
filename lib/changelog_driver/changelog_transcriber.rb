class ChangelogTranscriber
  def initialize(changelog)
    @changelog = changelog
  end

  def write_to(filepath)
    File.open(filepath, 'w+') { |file| file.write @changelog.to_a.join("\n") }
  end
end
