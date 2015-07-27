module Invoiced
	module Operations
		module Update
			def save
    			response = @client.request(:patch, @endpoint, @unsaved)

    			@values = response[:body].dup.merge({:id => self.id})
    			return response[:code] == 200
    		end
		end
	end
end