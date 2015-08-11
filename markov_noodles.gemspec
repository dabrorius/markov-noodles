Gem::Specification.new do |s|
  s.name        = 'markov_noodles'
  s.version     = '1.0.0'
  s.date        = Date.today.to_s
  s.summary     = 'Simple markov chain implementation'
  s.description = 'Noodles uses Markov chains to generate superficially '\
                  'real-looking text given a sample document.'
  s.authors     = ['Filip Defar']
  s.email       = 'filip.defar@gmail.com'
  s.files       = ['lib/markov_noodles.rb']
  s.homepage    = 'https://github.com/dabrorius/noodles'
  s.license     = 'MIT'

  s.add_runtime_dependency 'msgpack', '~> 0.6'
end
