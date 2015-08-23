require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class InvoiceTest < Test::Unit::TestCase
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
  end
end