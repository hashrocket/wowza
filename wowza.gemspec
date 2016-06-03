# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wowza/version'

Gem::Specification.new do |spec|
  spec.name          = "wowza"
  spec.version       = Wowza::VERSION
  spec.authors       = ["Chase McCarthy"]
  spec.email         = ["chase@code0100fun.com"]

  spec.summary       = %q{Wowza REST API wrapper}
  spec.description   = %q{Wowza REST API wrapper. ALPHA!}
  spec.homepage      = "https://github.com/hashrocket/wowza"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mock5", "~> 1.0.8"
  spec.add_development_dependency "pry"

  spec.add_dependency "indifference"
  spec.add_dependency "assignment"
end
