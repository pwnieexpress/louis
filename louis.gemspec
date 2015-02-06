# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'louis/version'

Gem::Specification.new do |spec|
  spec.name          = "louis"
  spec.version       = Louis::VERSION
  spec.authors       = ["Sam Stelfox"]
  spec.email         = ["sstelfox@bedroomprogrammers.net"]
  spec.summary       = %q{Library for looking up the the vendor associated with a MAC address.}
  spec.description   = %q{There is a public registry maintained by the IANA that is required to be used by all vendors operating in certains spaces. Ethernet, Bluetooth, and Wireless device manufacturers are all assigned unique prefixes. This database is available publicly online and can be used to identify the manufacturer of these devices. This library provides an easy mechanism to perform these lookups.}
  spec.homepage      = ""
  spec.license       = "AGPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "coveralls", "0.7.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"
end
