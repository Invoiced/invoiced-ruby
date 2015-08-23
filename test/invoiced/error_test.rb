require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class UtilTest < Test::Unit::TestCase
  	should "create an api error" do
  		error = ApiError.new("ERROR!", 500)
  		assert_equal("(500): ERROR!", error.to_s)
  	end
  end
end