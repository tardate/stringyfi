module FixturesHelper

  def xml_sample_path(name='chromatic.xml')
    File.join(xml_samples_path, name)
  end

  def xml_samples_path
    "#{File.dirname(__FILE__)}/../fixtures/music_xml"
  end
end

RSpec.configure do |conf|
  conf.include FixturesHelper
end