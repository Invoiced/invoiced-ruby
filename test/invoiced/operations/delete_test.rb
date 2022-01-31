module Invoiced
  module Operations
    module DeleteTest
      include ShouldaContextLoadable

      should "delete an object" do
        mockResponse = mock('RestClient::Response')
        mockResponse.stubs(:code).returns(204)
        mockResponse.stubs(:body).returns('')
        mockResponse.stubs(:headers).returns({})

        RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

        client = Invoiced::Client.new('api_key')
        obj = @objectClass.new(client, 1234)
        assert_true(obj.delete)
      end
    end
  end
end