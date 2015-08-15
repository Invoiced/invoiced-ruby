require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class InvoiceTest < Test::Unit::TestCase
    should "create an invoice" do
      invoice = @client.Invoice.create({:customer => 123})
    end

  	should "list all invoices" do
      @client.Invoice.list
  	end

    should "retrieve an invoice" do
      invoice = @client.Invoice.retrieve(1234)
    end

    should "update an invoice" do
      invoice = Invoice.new(@client, 1234)
      invoice.notes = 'Test'
      assert_true(invoice.save)
    end

    should "send an invoice" do
      invoice = Invoice.new(@client, 1234)
      assert_true(invoice.send)
    end

    should "delete an invoice" do
      invoie = Invoice.new(@client, 1234)
      assert_true(invoice.delete)
    end
  end
end