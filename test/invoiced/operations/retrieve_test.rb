module Invoiced
  module Operations
    module RetrieveTest
      include ShouldaContextLoadable

      should 'retrieve an object' do
        mockResponse = mock('RestClient::Response')
        mockResponse.stubs(:code).returns(200)
        mockResponse.stubs(:body).returns('{"id":123}')
        mockResponse.stubs(:headers).returns({})

        RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

        client = Invoiced::Client.new('api_key')
        obj = @objectClass.new(client).retrieve(123)

        assert_instance_of(@objectClass, obj)
        assert_equal(123, obj.id)
      end
    end
  end
end