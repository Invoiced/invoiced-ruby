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
			Util.build_objects(email, response[:body])
		end

		def balance
			response = @client.request(:get, "#{@endpoint}/balance")

			response[:body]
		end
	end
end