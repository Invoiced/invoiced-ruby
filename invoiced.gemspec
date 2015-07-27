$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'invoiced/version'

Gem::Specification.new do |s|
  s.name        = 'invoiced'
  s.version     = Invoiced::VERSION
  s.licenses    = ['MIT']
  s.summary     = "Ruby client library for the Invoiced API"
  s.description = "Invoiced makes invoicing and recurring billing dead simple"
  s.authors     = ["Jared King"]
  s.email       = 'api@invoiced.com'
  s.files       = ["lib/invoiced.rb"]
  s.homepage    = 'https://developers.invoiced.com'

  s.add_dependency('rest-client', '~> 1.8.0')
  s.add_dependency('json', '~> 1.8.3')

  s.add_development_dependency('mocha', '~> 0.13.2')
  s.add_development_dependency('shoulda', '~> 3.4.0')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('rake')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']
end
