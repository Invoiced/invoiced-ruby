require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class RefundTest < Test::Unit::TestCase
    should "return the api endpoint" do
      refund = Refund.new(@client, 123)
      assert_equal('/refunds/123', refund.endpoint())
    end

    should "create a refund" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":456}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      refund = Refund.new(@client, 1234)
      refund = refund.create(456, {:amount => 800})

      assert_instance_of(Invoiced::Refund, refund)
      assert_equal(456, refund.id)
    end
  end
end