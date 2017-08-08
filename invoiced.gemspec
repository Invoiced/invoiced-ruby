$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'invoiced/version'

Gem::Specification.new do |s|
  s.name        = 'invoiced'
  s.version     = Invoiced::VERSION
  s.licenses    = ['MIT']
  s.summary     = "Ruby client library for the Invoiced API"
  s.description = "Invoiced makes invoicing and recurring billing dead simple"
  s.authors     = ["Jared King"]
  s.email       = 'support@invoiced.com'
  s.files       = ["lib/invoiced.rb"]
  s.homepage    = 'https://invoiced.com/docs/dev'
  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency('rest-client', '~> 2.0.0')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']
end
