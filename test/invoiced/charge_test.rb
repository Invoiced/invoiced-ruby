require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class ChargeTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest

    setup do
      @objectClass = Charge
      @endpoint = '/charges'
    end

    should "create a charge" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"a1b2c3","amount":100,"object":"charge"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      charge = Charge.new(@client, 1234)
      payment = charge.create(:amount => 100, :payment_source_type => "card")

      assert_instance_of(Invoiced::Payment, payment)
      assert_equal(payment.id, "a1b2c3")
    end
  end
end