require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class CustomerTest < Test::Unit::TestCase
    should "create a customer" do
      customer = @client.Customer.create({:name => "test"})
    end

  	should "list all customers" do
      @client.Customer.list
  	end

    should "retrieve a customer" do
      customer = @client.Customer.retrieve(1234)
    end

    should "update a customer" do
      customer = Customer.new(@client, 1234)
      customer.name = 'Update'
      assert_true(customer.save)
    end

    should "send an account statement" do
      customer = Customer.new(@client, 1234)
      emails = customer.send_statement
    end

    should "retrieve a customer's balance" do
      customer = Customer.new(@client, 1234)
      balance = customer.balance
    end

    should "list all of the customer's subscriptions" do
      @client.Customer.subscriptions
    end

    should "delete a customer" do
      customer = Customer.new(@client, 1234)
      assert_true(customer.delete)
    end
  end
end