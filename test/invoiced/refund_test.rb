require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class RefundTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest

    setup do
      @objectClass = Refund
      @endpoint = '/refunds'
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