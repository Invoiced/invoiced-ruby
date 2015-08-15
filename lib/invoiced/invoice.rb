module Invoiced
    class Invoice < Object
		include Invoiced::Operations::List
		include Invoiced::Operations::Create
		include Invoiced::Operations::Update
		include Invoiced::Operations::Delete

		def send(opts={})
			response = @client.request(:post, "#{@endpoint}/emails", opts)

			# build email objects
			email = Email.new(@client)
			Util.build_objects(email, response[:body])
		end

		def pay
			response = @client.request(:post, "#{@endpoint}/pay")

			# update the local values with the response
			@values = response[:body].dup.merge({:id => self.id})

			return response[:code] == 200
		end
	end
end