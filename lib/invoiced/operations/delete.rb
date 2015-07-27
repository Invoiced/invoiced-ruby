module Invoiced
	module Operations
		module Delete
			def delete
    			response = @client.request(:delete, @endpoint)

    			@values = {:id => @id}

    			return response[:code] == 204
    		end
		end
	end
end