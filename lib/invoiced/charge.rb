module Invoiced
    class Charge < Object
        OBJECT_NAME = 'charge'

        def create(body={}, opts={})
            response = @client.request(:post, endpoint(), body, opts)

            payment = Payment.new(@client)
            Util.convert_to_object(payment, response[:body])
        end
    end
end