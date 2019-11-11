require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class TaxRateTest < Test::Unit::TestCase
    should "return the api endpoint" do
      tax_rate = TaxRate.new(@client, "test")
      assert_equal('/tax_rates/test', tax_rate.endpoint())
    end

    should "create a tax rate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test TaxRate"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      tax_rate = @client.TaxRate.create({:name => "Test TaxRate"})

      assert_instance_of(Invoiced::TaxRate, tax_rate)
      assert_equal("test", tax_rate.id)
      assert_equal('Test TaxRate', tax_rate.name)
    end

    should "retrieve a tax rate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test TaxRate"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      tax_rate = @client.TaxRate.retrieve("test")

      assert_instance_of(Invoiced::TaxRate, tax_rate)
      assert_equal("test", tax_rate.id)
      assert_equal('Test TaxRate', tax_rate.name)
    end

    should "not update a tax rate when no params" do
      tax_rate = TaxRate.new(@client, "test")
      assert_false(tax_rate.save)
    end

    should "update a tax rate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"new contents"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      tax_rate = TaxRate.new(@client, "test")
      tax_rate.name = "new contents"
      assert_true(tax_rate.save)

      assert_equal(tax_rate.name, 'new contents')
    end

    should "list all tax rates" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","name":"Test TaxRate"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/tax_rates?per_page=25&page=1>; rel="self", <https://api.invoiced.com/tax_rates?per_page=25&page=1>; rel="first", <https://api.invoiced.com/tax_rates?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      tax_rates, metadata = @client.TaxRate.list

      assert_instance_of(Array, tax_rates)
      assert_equal(1, tax_rates.length)
      assert_equal("test", tax_rates[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a tax rate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      tax_rate = TaxRate.new(@client, "test")
      assert_true(tax_rate.delete)
    end
  end
end