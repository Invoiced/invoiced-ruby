require 'invoiced'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'
require 'coveralls'

Coveralls.wear!

class Test::Unit::TestCase
  include Mocha

  setup do
    @client = Invoiced::Client.new('api_key')
  end
end