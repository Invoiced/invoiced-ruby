require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class SubscriptionTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::CreateTest
    include Invoiced::Operations::RetrieveTest
    include Invoiced::Operations::UpdateTest
    include Invoiced::Operations::DeleteTest
    include Invoiced::Operations::ListTest

    setup do
      @objectClass = Subscription
      @endpoint = '/subscriptions'
    end

    should "cancel a subscription" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"plan":"pro","status":"canceled"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      subscription = Subscription.new(@client, 123)
      assert_true(subscription.cancel)
      assert_equal("canceled", subscription.status)
    end

    should "preview a subscription" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"first_invoice": {"id": false}, "mrr": 9}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      subscription = Subscription.new(@client, 123)
      preview = subscription.preview(:customer => 1234, :plan => "enterprise")
      assert_equal(preview[:first_invoice], {:id=>false})
    end
  end
end