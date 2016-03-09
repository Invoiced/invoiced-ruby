module Invoiced
	module Operations
		module List
			def list(opts={})
    			response = @client.request(:get, self.endpoint(), opts)

    			# build objects
    			objects = Util.build_objects(self, response[:body])

				# store the metadata from the list operation
				metadata = Invoiced::List.new(response[:headers][:link], response[:headers][:x_total_count])

    			return objects, metadata
    		end
		end
	end
end