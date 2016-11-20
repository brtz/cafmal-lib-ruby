# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cafmal/version'

Gem::Specification.new do |spec|
  spec.name          = "cafmal"
  spec.version       = Cafmal::VERSION
  spec.authors       = ["Nils Bartels"]
  spec.email         = ["gem-cafmal@schrohm.de"]

  spec.summary       = %q{Create alerts from metrics and logs}
  spec.description   = %q{The cafmal library in ruby}
  spec.homepage      = "https://rubygems.org/gems/cafmal"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "httparty", "~> 0.14.0"
end
