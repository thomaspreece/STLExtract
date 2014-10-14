# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'STLExtract/version'

Gem::Specification.new do |spec|
  spec.name          = "STLExtract"
  spec.version       = STLExtract::VERSION
  spec.authors       = ["Thomas Preece"]
  spec.email         = ["RubyGems@thomaspreece.com"]
  spec.summary       = 'Extracts data from STL, OBJ and AMF files using Slic3r'
  spec.description   = 'Extracts x,y,z and volume data from STL, OBJ and AMF files using Slic3r'
  spec.homepage      = "http://thomaspreece.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
