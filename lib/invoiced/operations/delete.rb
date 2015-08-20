module Invoiced
	module Operations
		module Delete
			def delete
    			response = @client.request(:delete, @endpoint)

    			if response[:code] == 204
    				@values = {:id => @id}
    			end

    			return response[:code] == 204
    		end
		end
	end
end