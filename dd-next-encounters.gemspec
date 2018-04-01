Gem::Specification.new do |s|
  s.name        = 'dd-next-encounters'
  s.version     = '2.0.0'
  s.date        = '2018-03-26'
  s.summary     = 'Generate DD Next encounters'
  s.description = 'A simple gem that generate DD Next encounters'
  s.authors     = ['Cédric Zuger']
  s.email       = 'zuger.cedric@gmail.com'
  s.files       = Dir.glob('lib/**/*') + %w(README.md)
  s.homepage    =
      'https://github.com/czuger/dd-next-encounters'
  s.license       = 'MIT'
  s.add_dependency 'hazard', '~> 1'
  s.required_ruby_version = '>= 2.3.6'
end