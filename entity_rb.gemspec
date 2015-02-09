# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'entity_rb/version'

Gem::Specification.new do |spec|
  spec.name          = "entity_rb"
  spec.version       = Entity::VERSION
  spec.authors       = ["Caio Torres e Paulo Patto"]
  spec.email         = ["caio.a.torres@gmail.com"]
  spec.summary       = %q{An Entity implementation to store all business logic from the (so called) model.}
  spec.description   = %q{An Entity implementation in ruby to store all business logic from the (so called) model.}
  spec.homepage      = "https://github.com/efreesen/entity_rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
