require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class PaymentSourceTest < Test::Unit::TestCase
    should "return the api endpoint" do
      payment_source = Customer.new(@client, 1234).payment_sources()
      assert_equal('/customers/1234/payment_sources', payment_source.endpoint())
    end

    should "list all payment sources" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"object":"card"},{"id":234,"object":"bank_account"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/payment_sources?per_page=25&page=1>; rel="self", <https://api.invoiced.com/payment_sources?per_page=25&page=1>; rel="first", <https://api.invoiced.com/payment_sources?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      payment_source = PaymentSource.new(@client)
      payment_sources, metadata = payment_source.list

      assert_instance_of(Array, payment_sources)
      assert_instance_of(Invoiced::Card, payment_sources[0])
      assert_instance_of(Invoiced::BankAccount, payment_sources[1])
      assert_equal(2, payment_sources.length)
      assert_equal(123, payment_sources[0][:id])

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a card payment source" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      card = Card.new(@client, 123)
      card.object = 'card'
      assert_true(card.delete)
    end

    should "delete a bank account payment source" do
        mockResponse = mock('RestClient::Response')
        mockResponse.stubs(:code).returns(204)
        mockResponse.stubs(:body).returns('')
        mockResponse.stubs(:headers).returns({})

        RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

        bank_account = BankAccount.new(@client, 123)
        bank_account.object = 'bank_account'
        assert_true(bank_account.delete)
      end
  end
end