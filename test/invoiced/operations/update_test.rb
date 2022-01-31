module Invoiced
  module Operations
    module UpdateTest
      include ShouldaContextLoadable

      should "not update an object when no params" do
        client = Invoiced::Client.new('api_key')
        obj = @objectClass.new(client, "test")
        assert_false(obj.save)
      end

      should "update an object" do
        mockResponse = mock('RestClient::Response')
        mockResponse.stubs(:code).returns(200)
        mockResponse.stubs(:body).returns('{"id":1234,"closed":true}')
        mockResponse.stubs(:headers).returns({})

        RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

        client = Invoiced::Client.new('api_key')
        obj = @objectClass.new(client, 1234)
        obj.closed = true
        assert_true(obj.save)

        assert_true(obj.closed)
      end
    end
  end
end