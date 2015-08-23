require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class ObjectTest < Test::Unit::TestCase
  	should "create an invoiced object" do
  		client = Client.new("test")

  		object = Object.new(client, 123, {:name => "Pied Piper"})

  		assert_equal(client, object.client)
  		assert_equal("{\n  \"name\": \"Pied Piper\",\n  \"id\": 123\n}", object.to_s)
  		assert_equal("#<#{object.class}:0x#{object.object_id.to_s(16)} id=123> JSON: {\n  \"name\": \"Pied Piper\",\n  \"id\": 123\n}", object.inspect)
  		assert_equal("{\"name\":\"Pied Piper\",\"id\":123}", object.to_json)
  		assert_equal({:name => "Pied Piper", :id => 123}, object.to_hash)

  		object.each do |value|
  			# NOP
  		end
  	end

    should "throw exception when retrieving with no id" do
      assert_raise ArgumentError do
  		client = Client.new "test"

  		object = Object.new client

        object.retrieve nil
      end
    end

    should "add and remove accessors" do
  		client = Client.new("test")

  		object = Object.new(client, 123, {:name => "Pied Piper"})

  		assert_equal(123, object.id)
  		assert_equal("Pied Piper", object.name)
  		assert_equal("Pied Piper", object["name"])

  		object.name = "Renamed"
  		assert_equal("Renamed", object.name)

  		object["name"] = "Pied Piper"
  		assert_equal("Pied Piper", object["name"])

  		assert_equal([:name, :id], object.keys)
  		assert_equal(["Pied Piper", 123], object.values)

  		object.refresh_from({:id => 123, :notes => "...."})

  		# the name attribute should no longer be available
  		assert_equal("....", object.notes)
  		assert_raise NoMethodError do
  			object.name
  		end
	end

	should "raise exception when setting missing attribute" do
  		client = Client.new("test")

  		object = Object.new(client, 123)

		assert_raise NoMethodError do
			object.non_existent_method
		end
	end

	should "raise exception when setting empty string" do
  		client = Client.new("test")

  		object = Object.new(client, 123, {:name => "Pied Piper"})

		assert_raise ArgumentError do
			object.name = ""
		end
	end

	should "raise exception when attempting to set permanent attribute" do
  		client = Client.new("test")

  		object = Object.new(client, 123)

		assert_raise NoMethodError do
			object.id = "fail"
		end
	end
  end
end