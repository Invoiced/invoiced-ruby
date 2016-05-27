module Invoiced
    class Customer < Object
		include Invoiced::Operations::List
		include Invoiced::Operations::Create
		include Invoiced::Operations::Update
		include Invoiced::Operations::Delete

		def send_statement(opts={})
			response = @client.request(:post, "#{self.endpoint()}/emails", opts)

			# build email objects
			email = Email.new(@client)
			Util.build_objects(email, response[:body])
		end

		def balance
			response = @client.request(:get, "#{self.endpoint()}/balance")

			response[:body]
		end

		def line_items(opts={})
			line = LineItem.new(@client)
			line.set_endpoint_base(self.endpoint())
		end

		def invoice(opts={})
			response = @client.request(:post, "#{self.endpoint()}/invoices", opts)

			# build invoice object
			invoice = Invoice.new(@client)
			Util.convert_to_object(invoice, response[:body])
		end
	end
end