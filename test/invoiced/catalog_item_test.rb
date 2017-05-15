require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class CatalogItemTest < Test::Unit::TestCase
    should "return the api endpoint" do
      catalogItem = CatalogItem.new(@client, "test")
      assert_equal('/catalog_items/test', catalogItem.endpoint())
    end

    should "create a catalog item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Item"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      catalogItem = @client.CatalogItem.create({:name => "Test Item"})

      assert_instance_of(Invoiced::CatalogItem, catalogItem)
      assert_equal("test", catalogItem.id)
      assert_equal('Test Item', catalogItem.name)
    end

    should "retrieve a catalog item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Item"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      catalogItem = @client.CatalogItem.retrieve("test")

      assert_instance_of(Invoiced::CatalogItem, catalogItem)
      assert_equal("test", catalogItem.id)
      assert_equal('Test Item', catalogItem.name)
    end

    should "not update a catalog item when no params" do
      catalogItem = CatalogItem.new(@client, "test")
      assert_false(catalogItem.save)
    end

    should "update a catalog item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","closed":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      catalogItem = CatalogItem.new(@client, "test")
      catalogItem.closed = true
      assert_true(catalogItem.save)

      assert_true(catalogItem.closed)
    end

    should "list all catalog items" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","name":"Test Item"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="self", <https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="first", <https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      catalogItems, metadata = @client.CatalogItem.list

      assert_instance_of(Array, catalogItems)
      assert_equal(1, catalogItems.length)
      assert_equal("test", catalogItems[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a catalog item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      catalogItem = CatalogItem.new(@client, "test")
      assert_true(catalogItem.delete)
    end
  end
end