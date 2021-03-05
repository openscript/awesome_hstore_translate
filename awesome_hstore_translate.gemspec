# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awesome_hstore_translate/version'

Gem::Specification.new do |spec|
  spec.name          = 'awesome_hstore_translate'
  spec.version       = AwesomeHstoreTranslate::VERSION
  spec.authors       = ['Robin Bühler', 'Rob Worley']
  spec.email         = ['public+rubygems@openscript.ch']

  spec.summary       = 'Using PostgreSQLs hstore datatype to provide ActiveRecord models data translation.'
  spec.description   = 'This gem uses PostgreSQLs hstore datatype and ActiveRecord models to translate model data. It is based on the gem hstore_translate by Rob Worely.'
  spec.homepage      = 'https://github.com/openscript/awesome_hstore_translate'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|\.idea)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.0'
  spec.add_dependency 'activemodel', '>= 5.0'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'database_cleaner', '~> 1.5'
  spec.add_development_dependency 'pg', '~> 0.18'
  spec.add_development_dependency 'simplecov', '~> 0.12'
end
