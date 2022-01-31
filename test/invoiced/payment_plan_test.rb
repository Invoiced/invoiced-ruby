require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class PaymentPlanTest < Test::Unit::TestCase
    include Invoiced::Operations::CreateTest
    include Invoiced::Operations::DeleteTest

    setup do
      @objectClass = PaymentPlan
    end

    should "return the api endpoint" do
      paymentPlan = PaymentPlan.new(@client, 123)
      assert_equal('/payment_plan', paymentPlan.endpoint())
    end

    should "create a payment plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"status":"active"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      paymentPlan = PaymentPlan.new(@client)
      payment_plan = paymentPlan.create({:installments => [{"date"=>1234,"amount" => 100}]})

      assert_instance_of(Invoiced::PaymentPlan, payment_plan)
      assert_equal(123, payment_plan.id)
      assert_equal("active", payment_plan.status)
    end

    should "retrieve a payment plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"status":"active"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      paymentPlan = PaymentPlan.new(@client)
      payment_plan = paymentPlan.retrieve()

      assert_instance_of(Invoiced::PaymentPlan, payment_plan)
      assert_equal(123, payment_plan.id)
      assert_equal("active", payment_plan.status)
    end

    should "cancel a payment plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payment_plan = PaymentPlan.new(@client, 123)
      assert_true(payment_plan.cancel)
    end
  end
end