module Invoiced
  module Operations
    module CreateTest
      include ShouldaContextLoadable

      should "create a plan" do
        mockResponse = mock('RestClient::Response')
        mockResponse.stubs(:code).returns(201)
        mockResponse.stubs(:body).returns('{"id":"test"}')
        mockResponse.stubs(:headers).returns({})

        RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

        client = Invoiced::Client.new('api_key')
        obj = @objectClass.new(client).create({:name => "Test"})

        assert_instance_of(@objectClass, obj)
        assert_equal("test", obj.id)
      end
    end
  end
end