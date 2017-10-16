class StringyFi::Shell

  attr_accessor :converter

  def initialize(args=[])
    filename = args.first || File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures', 'music_xml', 'chromatic.xml')
    self.converter = StringyFi::Converter.new(filename)
  end

  def convert!
    converter.convert!
  end
end