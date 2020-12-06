require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class PaymentTest < Test::Unit::TestCase
    should "return the api endpoint" do
      payment = Payment.new(@client, 123)
      assert_equal('/payments/123', payment.endpoint())
    end

    should "create a payment" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"amount":100}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payment = @client.Payment.create({:amount => 800})

      assert_instance_of(Invoiced::Payment, payment)
      assert_equal(123, payment.id)
      assert_equal(100, payment.amount)
    end

    should "retrieve a payment" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"amount":100}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payment = @client.Payment.retrieve(123)

      assert_instance_of(Invoiced::Payment, payment)
      assert_equal(123, payment.id)
      assert_equal(100, payment.amount)
    end

    should "not update a payment when no params" do
      payment = Payment.new(@client, 123)
      assert_false(payment.save)
    end

    should "update a payment" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"sent":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payment = Payment.new(@client, 123)
      payment.sent = true
      assert_true(payment.save)

      assert_true(payment.sent)
    end

    should "list all payments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"amount":100}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/payments?per_page=25&page=1>; rel="self", <https://api.invoiced.com/payments?per_page=25&page=1>; rel="first", <https://api.invoiced.com/payments?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payments, metadata = @client.Payment.list

      assert_instance_of(Array, payments)
      assert_equal(1, payments.length)
      assert_equal(123, payments[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a payment" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payment = Payment.new(@client, 123)
      assert_true(payment.delete)
    end

    should "send a payment receipt" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('[{"id":4567,"email":"test@example.com"}]')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payment = Payment.new(@client, 1234)
      emails = payment.send

      assert_instance_of(Array, emails)
      assert_equal(1, emails.length)
      assert_instance_of(Invoiced::Email, emails[0])
      assert_equal(4567, emails[0].id)
    end
  end
end