require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class ItemTest < Test::Unit::TestCase
    should "return the api endpoint" do
      item = Item.new(@client, "test")
      assert_equal('/items/test', item.endpoint())
    end

    should "create an item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Item"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      item = @client.Item.create({:name => "Test Item"})

      assert_instance_of(Invoiced::Item, item)
      assert_equal("test", item.id)
      assert_equal('Test Item', item.name)
    end

    should "retrieve an item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Item"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      item = @client.Item.retrieve("test")

      assert_instance_of(Invoiced::Item, item)
      assert_equal("test", item.id)
      assert_equal('Test Item', item.name)
    end

    should "not update an item when no params" do
      item = Item.new(@client, "test")
      assert_false(item.save)
    end

    should "update an item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","closed":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      item = Item.new(@client, "test")
      item.closed = true
      assert_true(item.save)

      assert_true(item.closed)
    end

    should "list all items" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","name":"Test Item"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/items?per_page=25&page=1>; rel="self", <https://api.invoiced.com/items?per_page=25&page=1>; rel="first", <https://api.invoiced.com/items?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      items, metadata = @client.Item.list

      assert_instance_of(Array, items)
      assert_equal(1, items.length)
      assert_equal("test", items[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete an item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      item = Item.new(@client, "test")
      assert_true(item.delete)
    end
  end
end