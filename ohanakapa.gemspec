# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ohanakapa/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'sawyer', '~> 0.3.0'
  spec.add_development_dependency "bundler", "~> 1.0"
  spec.authors       = ["Anselm Bradford", "Moncef Belyamani"]
  spec.description   = %q{A Ruby wrapper for the Ohana API.}
  spec.email         = ["ohana@codeforamerica.org"]
  spec.files         = %w(CONTRIBUTING.md LICENSE.md README.md Rakefile ohanakapa.gemspec)
  spec.files         = Dir.glob("lib/**/*.rb")
  spec.files         += Dir.glob("spec/**/*")
  spec.homepage      = "https://github.com/codeforamerica/ohanakapa"
  spec.licenses      = ["MIT"]
  spec.name          = "ohanakapa"
  spec.post_install_message = "Connect to Ohana. Connect your Community."
  spec.require_paths = ["lib"]
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary       = spec.description
  spec.test_files    = Dir.glob("spec/**/*")
  spec.version       = Ohanakapa::VERSION.dup
end