module Invoiced
    module Operations
        module Create
            def create(body={}, opts={})
                response = @client.request(:post, self.endpoint(), body, opts)

                Util.convert_to_object(self, response[:body])
            end
        end
    end
end