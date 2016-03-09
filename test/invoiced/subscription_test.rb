require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class SubscriptionTest < Test::Unit::TestCase
    should "return the api endpoint" do
      subscription = Subscription.new(@client, 123)
      assert_equal('/subscriptions/123', subscription.endpoint())
    end

    should "create a subscription" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"plan":"starter"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      subscription = @client.Subscription.create({:customer => 456})

      assert_instance_of(Invoiced::Subscription, subscription)
      assert_equal(123, subscription.id)
      assert_equal("starter", subscription.plan)
    end

    should "retrieve a subscription" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"plan":"starter"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      subscription = @client.Subscription.retrieve(123)

      assert_instance_of(Invoiced::Subscription, subscription)
      assert_equal(123, subscription.id)
      assert_equal("starter", subscription.plan)
    end

    should "not update a subscription when no params" do
      subscription = Subscription.new(@client, 123)
      assert_false(subscription.save)
    end

    should "update a subscription" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"plan":"pro"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      subscription = Subscription.new(@client, 123)
      subscription.plan = "pro"
      assert_true(subscription.save)

      assert_equal("pro", subscription.plan)
    end

    should "list all subscriptions" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"plan":"pro"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/subscriptions?per_page=25&page=1>; rel="self", <https://api.invoiced.com/subscriptions?per_page=25&page=1>; rel="first", <https://api.invoiced.com/subscriptions?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      subscriptions, metadata = @client.Subscription.list

      assert_instance_of(Array, subscriptions)
      assert_equal(1, subscriptions.length)
      assert_equal(123, subscriptions[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "cancel a subscription" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      subscription = Subscription.new(@client, 123)
      assert_true(subscription.cancel)
    end
  end
end