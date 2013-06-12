# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/promises/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-promises"
  spec.version       = Rack::Promises::VERSION
  spec.authors       = ["Joel Jackson"]
  spec.email         = ["jackson.joel@gmail.com"]
  spec.description   = %q{Envelops rack call requests in a cushy warm promise so you don't have to worry.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/joeljackson/rack-promises"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "em-promise", "~> 1.1.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "awesome_print"
end
