require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class UtilTest < Test::Unit::TestCase
  	should "create an authorization header string" do
  		assert_equal('Basic dGVzdDo=', Util.auth_header("test"))
  	end

    should "build a URI encoded string" do
        params = {
          "test" => "property",
          "filter" => {
            "levels" => "work",
            "nesting" => {
              "works" => true
            }
          },
          "array" => [
              "should",
              {"also" => true},
              ["work"]
          ]
        }

        assert_equal("test=property&filter[levels]=work&filter[nesting][works]=true&array[]=should&array[][also]=true&array[]=work", Util.uri_encode(params))
    end

    should "create a Customer object" do
      instance = Invoiced::Customer.new(@client)
      customer = Util.convert_to_object(instance.client, instance, {:id => 100})
      assert_equal('Invoiced::Customer', customer.class.name)
      assert_equal(100, customer.id)
    end

    should "create a collection of Customer objects" do
      instance = Invoiced::Customer.new(@client)
      objects = [{:id => 100}, {:id => 101}]
      customers = Util.build_objects(instance, objects)

      assert_equal(2, customers.length)
      assert_equal(100, customers[0].id)
      assert_equal(101, customers[1].id)
    end
  end
end