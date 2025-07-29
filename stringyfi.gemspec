# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stringyfi/version'

Gem::Specification.new do |spec|
  spec.name          = 'stringyfi'
  spec.version       = StringyFi::VERSION
  spec.authors       = ['Paul Gallagher']
  spec.email         = ['gallagher.paul@gmail.com']
  spec.summary       = 'Convert MusicXML to PIC assembler for the Boldport Stringy'
  spec.homepage      = 'https://github.com/tardate/stringyfi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.18'
end
