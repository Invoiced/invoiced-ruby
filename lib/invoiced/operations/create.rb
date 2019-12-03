module Invoiced
    module Operations
        module Create
            def create(body={}, opts={})
                response = @client.request(:post, endpoint(), body, opts)

                Util.convert_to_object(client, self, response[:body])
            end
        end
    end
end