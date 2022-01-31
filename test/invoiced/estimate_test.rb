require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class EstimateTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::CreateTest
    include Invoiced::Operations::RetrieveTest
    include Invoiced::Operations::UpdateTest
    include Invoiced::Operations::DeleteTest
    include Invoiced::Operations::ListTest

    setup do
      @objectClass = Estimate
      @endpoint = '/estimates'
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