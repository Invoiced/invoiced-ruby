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