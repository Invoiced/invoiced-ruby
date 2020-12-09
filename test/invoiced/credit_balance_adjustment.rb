require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class CreditBalanceAdjustmentTest < Test::Unit::TestCase
    should "return the api endpoint" do
      creditBalanceAdjustment = CreditBalanceAdjustment.new(@client, "test")
      assert_equal('/credit_balance_adjustment/test', creditBalanceAdjustment.endpoint())
    end

    should "create a credit balance adjustments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","amount":800}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditBalanceAdjustment = @client.CreditBalanceAdjustment.create({:amount => 800})

      assert_instance_of(Invoiced::CreditBalanceAdjustment, creditBalanceAdjustment)
      assert_equal("test", creditBalanceAdjustment.id)
      assert_equal(800, creditBalanceAdjustment.amount)
    end

    should "retrieve a credit balance adjustments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","amount":800}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditBalanceAdjustment = @client.CreditBalanceAdjustment.retrieve("test")

      assert_instance_of(Invoiced::CreditBalanceAdjustment, creditBalanceAdjustment)
      assert_equal("test", creditBalanceAdjustment.id)
      assert_equal(800, creditBalanceAdjustment.amount)
    end

    should "not update a credit balance adjustments when no params" do
      creditBalanceAdjustment = CreditBalanceAdjustment.new(@client, "test")
      assert_false(creditBalanceAdjustment.save)
    end

    should "update a credit balance adjustments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","amount":800}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditBalanceAdjustment = CreditBalanceAdjustment.new(@client, "test")
      creditBalanceAdjustment.amount = 800
      assert_true(creditBalanceAdjustment.save)

      assert_equal(creditBalanceAdjustment.amount, 800)
    end

    should "list all credit balance adjustments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","amount":800}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="self", <https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="first", <https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditBalanceAdjustments, metadata = @client.CreditBalanceAdjustment.list

      assert_instance_of(Array, creditBalanceAdjustments)
      assert_equal(1, creditBalanceAdjustments.length)
      assert_equal("test", creditBalanceAdjustments[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a credit balance adjustments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditBalanceAdjustment = CreditBalanceAdjustment.new(@client, "test")
      assert_true(creditBalanceAdjustment.delete)
    end
  end
end