require 'simplecov'
require 'simplecov-console'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::Console,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start do
  add_filter 'test/'
end

require 'invoiced'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'

class Test::Unit::TestCase
  include Mocha

  setup do
    @client = Invoiced::Client.new('api_key')
  end
end