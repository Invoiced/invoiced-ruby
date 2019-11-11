require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class TransactionTest < Test::Unit::TestCase
    should "return the api endpoint" do
      transaction = Transaction.new(@client, 123)
      assert_equal('/transactions/123', transaction.endpoint())
    end

    should "create a transaction" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"amount":100}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transaction = @client.Transaction.create({:amount => 800})

      assert_instance_of(Invoiced::Transaction, transaction)
      assert_equal(123, transaction.id)
      assert_equal(100, transaction.amount)
    end

    should "retrieve a transaction" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"amount":100}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transaction = @client.Transaction.retrieve(123)

      assert_instance_of(Invoiced::Transaction, transaction)
      assert_equal(123, transaction.id)
      assert_equal(100, transaction.amount)
    end

    should "not update a transaction when no params" do
      transaction = Transaction.new(@client, 123)
      assert_false(transaction.save)
    end

    should "update a transaction" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"sent":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transaction = Transaction.new(@client, 123)
      transaction.sent = true
      assert_true(transaction.save)

      assert_true(transaction.sent)
    end

    should "list all transactions" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"amount":100}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/transactions?per_page=25&page=1>; rel="self", <https://api.invoiced.com/transactions?per_page=25&page=1>; rel="first", <https://api.invoiced.com/transactions?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transactions, metadata = @client.Transaction.list

      assert_instance_of(Array, transactions)
      assert_equal(1, transactions.length)
      assert_equal(123, transactions[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a transaction" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transaction = Transaction.new(@client, 123)
      assert_true(transaction.delete)
    end

    should "send a payment receipt" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('[{"id":4567,"email":"test@example.com"}]')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transaction = Transaction.new(@client, 1234)
      emails = transaction.send

      assert_instance_of(Array, emails)
      assert_equal(1, emails.length)
      assert_instance_of(Invoiced::Email, emails[0])
      assert_equal(4567, emails[0].id)
    end

    should "refund a transaction" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":456}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transaction = Transaction.new(@client, 1234)
      refund = transaction.refund({:amount => 800})

      assert_instance_of(Invoiced::Transaction, refund)
      assert_equal(456, refund.id)
    end

    should "initiate a charge" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"a1b2c3","amount":100,"object":"card"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      transaction = Transaction.new(@client, 1234)
      charge = transaction.initiate_charge(:amount => 100, :payment_source_type => "card")

      assert_instance_of(Invoiced::Transaction, charge)
      assert_equal(charge.id, "a1b2c3")
    end
  end
end