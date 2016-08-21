module Invoiced
	module Operations
		module Delete
			def delete
    			response = @client.request(:delete, self.endpoint())

    			if response[:code] == 204
                    refresh_from({:id => @id})
                elsif response[:code] == 200
                    # update the local values with the response
                    refresh_from(response[:body].dup.merge({:id => self.id}))
    			end

    			return response[:code] == 204 || response[:code] == 200
    		end
		end
	end
end