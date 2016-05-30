require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class FileTest < Test::Unit::TestCase
    should "return the api endpoint" do
      file = File.new(@client, 123)
      assert_equal('/files/123', file.endpoint())
    end

    should "create a file" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"name":"Filename"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      file = File.new(@client)
      file = file.create({:name => "Filename"})

      assert_instance_of(Invoiced::File, file)
      assert_equal(123, file.id)
      assert_equal("Filename", file.name)
    end

    should "retrieve a file" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"name":"Filename"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      file = File.new(@client)
      file = file.retrieve(123)

      assert_instance_of(Invoiced::File, file)
      assert_equal(123, file.id)
      assert_equal("Filename", file.name)
    end

    should "delete a file" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      file = File.new(@client, 123)
      assert_true(file.delete)
    end
  end
end