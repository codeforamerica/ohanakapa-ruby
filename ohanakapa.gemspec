# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ohanakapa/version'

Gem::Specification.new do |spec|
  spec.name          = "ohanakapa"
  spec.version       = Ohanakapa::VERSION
  spec.authors       = ["Anselm Bradford", "Moncef Belyamani", "Sophia Parafina"]
  spec.email         = ["ohana@codeforamerica.org"]
  spec.description   = %q{A Ruby interface to the Ohana API.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/codeforamerica/ohanakapa"
  spec.license       = "MIT"

  spec.files         = Dir.glob("lib/**/*.rb")
  spec.files         += Dir.glob("spec/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.has_rdoc      = 'yard'

  spec.add_dependency 'sawyer', '~> 0.3.0'
  spec.add_dependency 'hashie', '~> 2.0'
  spec.add_dependency 'multi_json', '~> 1.3'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rspec", ">= 2.11"
  spec.add_development_dependency "vcr", "~> 2.4.0"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "json"
  spec.add_development_dependency "webmock", "~> 1.9.0"

  spec.post_install_message = "Connect to Ohana. Connect your Community."
end
