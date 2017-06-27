# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'markov_noodles/version'

Gem::Specification.new do |spec|
  spec.name          = 'markov_noodles'
  spec.version       = MarkovNoodles::VERSION
  spec.authors       = ['Filip Defar']
  spec.email         = 'filip.defar@gmail.com'
  spec.homepage      = 'https://github.com/dabrorius/noodles'
  spec.license       = 'MIT'

  spec.summary       = 'Simple markov chain implementation'
  spec.description   = <<~END
    Noodles uses Markov chains to generate superficially real-looking text given a sample document.
  END

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'yard'

  spec.add_dependency 'msgpack', '~> 1.1.0'
end
