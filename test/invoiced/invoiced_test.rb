require 'invoiced'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'

module Invoiced
  class InvoicedTest < Test::Unit::TestCase
  	should "create new client" do
  		client = Invoiced::Client.new('api_key')
  		assert_equal('api_key', client.api_key)
  	end

  	should "perform a request" do
  		client = Invoiced::Client.new('api_key')
  		params = {
  			"test" => "property",
  			"filter" => {
  				"levels" => "work"
  			}
  		}
  		client.request("GET", "/invoices", params)
  	end
  end
end