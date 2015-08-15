module Invoiced
    class Customer < Object
		include Invoiced::Operations::List
		include Invoiced::Operations::Create
		include Invoiced::Operations::Update
		include Invoiced::Operations::Delete

		def send_statement(opts={})
			response = @client.request(:post, "#{@endpoint}/emails", opts)

			# build email objects
			email = Email.new(@client)
			emails = Util.build_objects(email, response[:body])

			return emails
		end
	end
end