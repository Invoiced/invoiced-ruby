require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class EstimateTest < Test::Unit::TestCase
    should "return the api endpoint" do
      estimate = Estimate.new(@client, 123)
      assert_equal('/estimates/123', estimate.endpoint())
    end

    should "create an estimate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"number":"EST-0001"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = @client.Estimate.create({:number => "EST-0001"})

      assert_instance_of(Invoiced::Estimate, estimate)
      assert_equal(123, estimate.id)
      assert_equal('EST-0001', estimate.number)
    end

    should "retrieve an estimate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"number":"EST-0001"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = @client.Estimate.retrieve(123)

      assert_instance_of(Invoiced::Estimate, estimate)
      assert_equal(123, estimate.id)
      assert_equal('EST-0001', estimate.number)
    end

    should "not update an estimate when no params" do
      estimate = Estimate.new(@client, 123)
      assert_false(estimate.save)
    end

    should "update an estimate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"closed":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = Estimate.new(@client, 123)
      estimate.closed = true
      assert_true(estimate.save)

      assert_true(estimate.closed)
    end

    should "list all estimates" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"number":"EST-0001"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/estimates?per_page=25&page=1>; rel="self", <https://api.invoiced.com/estimates?per_page=25&page=1>; rel="first", <https://api.invoiced.com/estimates?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimates, metadata = @client.Estimate.list

      assert_instance_of(Array, estimates)
      assert_equal(1, estimates.length)
      assert_equal(123, estimates[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete an estimate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = Estimate.new(@client, 123)
      assert_true(estimate.delete)
    end

    should "send an estimate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('[{"id":4567,"email":"test@example.com"}]')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = Estimate.new(@client, 1234)
      emails = estimate.send

      assert_instance_of(Array, emails)
      assert_equal(1, emails.length)
      assert_instance_of(Invoiced::Email, emails[0])
      assert_equal(4567, emails[0].id)
    end

    should "create an invoice" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":4567,"total":100}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = Estimate.new(@client, 123)
      invoice = estimate.generate_invoice

      assert_instance_of(Invoiced::Invoice, invoice)
      assert_equal(4567, invoice.id)
    end

    should "list all of the estimate's attachments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"file":{"id":456}}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 10, :link => '<https://api.invoiced.com/estimates/123/attachments?per_page=25&page=1>; rel="self", <https://api.invoiced.com/estimates/123/attachments?per_page=25&page=1>; rel="first", <https://api.invoiced.com/estimates/123/attachments?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = Estimate.new(@client, 123)
      attachments, metadata = estimate.attachments

      assert_instance_of(Array, attachments)
      assert_equal(1, attachments.length)
      assert_equal(456, attachments[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(10, metadata.total_count)
    end

    should "void an estimate" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"status":"voided"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      estimate = Estimate.new(@client, 123)
      assert_true(estimate.void)

      assert_equal(estimate.status, 'voided')
    end
  end
end