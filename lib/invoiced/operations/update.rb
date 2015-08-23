module Invoiced
	module Operations
		module Update
			def save(params = {})
		        update = {}

		        @unsaved.each do |k|
		        	update[k] = @values[k]
		        end

		        update.merge(params)

				# perform the update if there are any changes
		        if update.length > 0
    				response = @client.request(:patch, @endpoint, update)

    				# update the local values with the response
    				@values = response[:body].dup.merge({:id => self.id})
    				@unsaved = Set.new

    				return response[:code] == 200
		        end

		        false
    		end
		end
	end
end