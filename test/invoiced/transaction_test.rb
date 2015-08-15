require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class TransactionTest < Test::Unit::TestCase
    should "create a transaction" do
      transaction = @client.Transaction.create({:invoice => 123, :amount => 800})
    end

  	should "list all transactions" do
      @client.Transaction.list
  	end

    should "retrieve a transaction" do
      transaction = @client.Transaction.retrieve(1234)
    end

    should "update a transaction" do
      transaction = Transaction.new(@client, 1234)
      transaction.notes = 'Update'
      assert_true(transaction.save)
    end

    should "send a payment receipt" do
      transaction = Transaction.new(@client, 1234)
      emails = transaction.send
    end

    should "delete a transaction" do
      transaction = Transaction.new(@client, 1234)
      assert_true(transaction.delete)
    end
  end
end