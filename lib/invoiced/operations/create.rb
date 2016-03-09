module Invoiced
	module Operations
		module Create
			def create(body={})
    			response = @client.request(:post, self.endpoint(), body)

    			Util.convert_to_object(self, response[:body])
    		end
		end
	end
end