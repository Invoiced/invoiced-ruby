require 'invoiced'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'

module Invoiced
  class UtilTest < Test::Unit::TestCase
  	should "create an authorization header string" do
  		assert_equal('Basic dGVzdDo=', Util.auth_header("test"))
  	end

    should "build a URI encoded string" do
        params = {
          "test" => "property",
          "filter" => {
            "levels" => "work"
          }
        }

        assert_equal("test=property&filter[levels]=work", Util.uri_encode(params))
    end
  end
end