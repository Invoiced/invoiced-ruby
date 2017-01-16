require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class InvoiceTest < Test::Unit::TestCase
    should "return the api endpoint" do
      invoice = Invoice.new(@client, 123)
      assert_equal('/invoices/123', invoice.endpoint())
    end

    should "create an invoice" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"number":"INV-0001"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = @client.Invoice.create({:number => "INV-0001"})

      assert_instance_of(Invoiced::Invoice, invoice)
      assert_equal(123, invoice.id)
      assert_equal('INV-0001', invoice.number)
    end

    should "retrieve an invoice" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"number":"INV-0001"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = @client.Invoice.retrieve(123)

      assert_instance_of(Invoiced::Invoice, invoice)
      assert_equal(123, invoice.id)
      assert_equal('INV-0001', invoice.number)
    end

    should "not update an invoice when no params" do
      invoice = Invoice.new(@client, 123)
      assert_false(invoice.save)
    end

    should "update an invoice" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"closed":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = Invoice.new(@client, 123)
      invoice.closed = true
      assert_true(invoice.save)

      assert_true(invoice.closed)
    end

    should "list all invoices" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"number":"INV-0001"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/invoices?per_page=25&page=1>; rel="self", <https://api.invoiced.com/invoices?per_page=25&page=1>; rel="first", <https://api.invoiced.com/invoices?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoices, metadata = @client.Invoice.list

      assert_instance_of(Array, invoices)
      assert_equal(1, invoices.length)
      assert_equal(123, invoices[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete an invoice" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = Invoice.new(@client, 123)
      assert_true(invoice.delete)
    end

    should "send an invoice" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('[{"id":4567,"email":"test@example.com"}]')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = Invoice.new(@client, 1234)
      emails = invoice.send

      assert_instance_of(Array, emails)
      assert_equal(1, emails.length)
      assert_instance_of(Invoiced::Email, emails[0])
      assert_equal(4567, emails[0].id)
    end

    should "pay an invoice" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"paid":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = Invoice.new(@client, 1234)
      assert_true(invoice.pay)

      assert_true(invoice.paid)
    end

    should "list all of the invoice's attachments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"file":{"id":456}}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 10, :link => '<https://api.invoiced.com/invoices/123/attachments?per_page=25&page=1>; rel="self", <https://api.invoiced.com/invoices/123/attachments?per_page=25&page=1>; rel="first", <https://api.invoiced.com/invoices/123/attachments?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = Invoice.new(@client, 123)
      attachments, metadata = invoice.attachments

      assert_instance_of(Array, attachments)
      assert_equal(1, attachments.length)
      assert_equal(456, attachments[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(10, metadata.total_count)
    end

    should "create a payment plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"status":"active"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = Invoice.new(@client, 456)
      payment_plan = invoice.payment_plan.create({:installments => [{"date"=>1234,"amount" => 100}]})

      assert_instance_of(Invoiced::PaymentPlan, payment_plan)
      assert_equal(123, payment_plan.id)
      assert_equal("active", payment_plan.status)
      assert_equal('/invoices/456/payment_plan', payment_plan.endpoint())
    end

    should "retrieve a payment plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"status":"active"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      invoice = Invoice.new(@client, 456)
      payment_plan = invoice.payment_plan.retrieve()

      assert_instance_of(Invoiced::PaymentPlan, payment_plan)
      assert_equal(123, payment_plan.id)
      assert_equal("active", payment_plan.status)
      assert_equal('/invoices/456/payment_plan', payment_plan.endpoint())
    end
  end
end