module Invoiced
  module Operations
    module EndpointTest
      include ShouldaContextLoadable

      should "return the api endpoint" do
        client = Invoiced::Client.new('api_key')
        obj = @objectClass.new(client, 1234)
        assert_equal(@endpoint + '/1234', obj.endpoint())
      end
    end
  end
end