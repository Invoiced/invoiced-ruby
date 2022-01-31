module Invoiced
  module Operations
    module ListTest
      include ShouldaContextLoadable

      should "list all objects" do
        mockResponse = mock('RestClient::Response')
        mockResponse.stubs(:code).returns(200)
        mockResponse.stubs(:body).returns('[{"id":1234}]')
        mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com' + @endpoint + '?per_page=25&page=1>; rel="self", <https://api.invoiced.com' + @endpoint + '?per_page=25&page=1>; rel="first", <https://api.invoiced.com' + @endpoint + '?per_page=25&page=1>; rel="last"')

        RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

        client = Invoiced::Client.new('api_key')
        objects, metadata = @objectClass.new(client).list

        assert_instance_of(Array, objects)
        assert_equal(1, objects.length)
        assert_equal(1234, objects[0].id)

        assert_instance_of(Invoiced::List, metadata)
        assert_equal(15, metadata.total_count)
      end
    end
  end
end