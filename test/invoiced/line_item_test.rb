require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class LineItemTest < Test::Unit::TestCase
    should "return the api endpoint" do
      line = LineItem.new(@client, 123)
      assert_equal('/line_items/123', line.endpoint())
    end

    should "create a line item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"unit_cost":500}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      line = LineItem.new(@client)
      line_item = line.create({:unit_cost => 500})

      assert_instance_of(Invoiced::LineItem, line_item)
      assert_equal(123, line_item.id)
      assert_equal(500, line_item.unit_cost)
    end

    should "retrieve a line item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"unit_cost":500}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      line = LineItem.new(@client)
      line_item = line.retrieve(123)

      assert_instance_of(Invoiced::LineItem, line_item)
      assert_equal(123, line_item.id)
      assert_equal(500, line_item.unit_cost)
    end

    should "not update a line item when no params" do
      line_item = LineItem.new(@client, 123)
      assert_false(line_item.save)
    end

    should "update a line item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"unit_cost":400}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      line_item = LineItem.new(@client, 123)
      line_item.unit_cost = 400
      assert_true(line_item.save)

      assert_equal(400, line_item.unit_cost)
    end

    should "list all line items" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"unit_cost":500}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/line_items?per_page=25&page=1>; rel="self", <https://api.invoiced.com/line_items?per_page=25&page=1>; rel="first", <https://api.invoiced.com/line_items?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      line_item = LineItem.new(@client)
      line_items, metadata = line_item.list

      assert_instance_of(Array, line_items)
      assert_equal(1, line_items.length)
      assert_equal(123, line_items[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a line item" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      line_item = LineItem.new(@client, 123)
      assert_true(line_item.delete)
    end
  end
end