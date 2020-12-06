module Invoiced
    class Refund < Object
        OBJECT_NAME = 'refund'

        def create(chargeId, body={}, opts={})
            response = @client.request(:post, @endpoint_base + "/charges/#{chargeId}/refunds", body, opts)

            Util.convert_to_object(self, response[:body])
        end
    end
end