module Invoiced
	module Operations
		module Delete
			def delete
    			response = @client.request(:delete, self.endpoint())

    			if response[:code] == 204
                    refresh_from({:id => @id})
    			end

    			return response[:code] == 204
    		end
		end
	end
end