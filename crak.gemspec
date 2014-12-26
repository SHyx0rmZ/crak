# coding: utf-8

require_relative 'lib/crak/version'

Gem::Specification.new do |spec|
  spec.name          = 'crak'
  spec.version       = Crak::VERSION
  spec.authors       = [ 'Patrick Pokatilo' ]
  spec.email         = [ 'mail@shyxormz.net' ]
  spec.summary       = 'Enhancements for building native applications with Rake'
  spec.description   = 'Adds new task types and provides a default build environment for developing native applications with Rake'
  spec.homepage      = 'http://github.com/SHyx0rmZ/crak'
  spec.license       = 'MIT'

  spec.files         = Dir[ 'bin/**/*', 'lib/**/*.rb' ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = [ 'lib' ]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.1'
end
