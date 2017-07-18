# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diachronr/version'

Gem::Specification.new do |gem|
  gem.name          = 'diachronr'
  gem.version       = Diachronr::VERSION
  gem.authors       = ['Miker Irick']
  gem.email         = ['michaelirick@gmail.com']
  gem.description   = 'applies sound changes to constructed languages'
  gem.summary       = 'applies diachronic sound changes to constructed languages'
  gem.homepage      = 'http://michaelirick.com'
  gem.license       = 'Nonstandard'

  gem.files         = `git ls-files`.split($RS)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'slop', '~> 3.4'

  gem.add_development_dependency 'simplecov', '~> 0'
  gem.add_development_dependency 'pry', '~> 0'
  gem.add_development_dependency 'rake', '~> 0'
end
