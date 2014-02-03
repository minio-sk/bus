# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bus/version'

Gem::Specification.new do |spec|
  spec.name          = "bus"
  spec.version       = Bus::VERSION
  spec.authors       = ["Jan Suchal"]
  spec.email         = ["johno@jsmf.net"]
  spec.summary       = %q{Lightweight message bus without mixins, globals or mutable state.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
