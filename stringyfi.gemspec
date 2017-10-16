# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stringyfi/version'

Gem::Specification.new do |spec|
  spec.name          = "stringyfi"
  spec.version       = StringyFi::VERSION
  spec.authors       = ["Paul Gallagher"]
  spec.email         = ["gallagher.paul@gmail.com"]
  spec.summary       = "Convert MusicXML to PIC assembler for the Boldport Stringy"
  spec.homepage      = "https://github.com/tardate/stringyfi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  # guard versions are pegged to avoid issue with ruby_dep requires Ruby version >= 2.2.5, ~> 2.2.
  spec.add_development_dependency "guard-rspec", "4.6.4"
  spec.add_development_dependency "rb-fsevent", "0.9.6"
  spec.add_development_dependency "rb-inotify", "0.9.5"
  spec.add_development_dependency "pry-coolline", "0.2.5" # avoid readline dependency
end
