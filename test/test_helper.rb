require 'simplecov'
require 'simplecov-console'
require 'coveralls'

SimpleCov.formatters = [
  SimpleCov::Formatter::Console,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'test/'
end

require 'invoiced'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'
require 'invoiced/operations/list_test'
require 'invoiced/operations/create_test'
require 'invoiced/operations/endpoint_test'
require 'invoiced/operations/update_test'
require 'invoiced/operations/delete_test'
require 'invoiced/operations/retrieve_test'

class Test::Unit::TestCase
  include Mocha

  setup do
    @client = Invoiced::Client.new('api_key')
  end
end