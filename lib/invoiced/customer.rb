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

		def subscriptions(opts={})
			response = @client.request(:get, "#{self.endpoint()}/subscriptions", opts)

			# build objects
			subscription = Subscription.new(@client)
			subscriptions = Util.build_objects(subscription, response[:body])

			# store the metadata from the list operation
			metadata = Invoiced::List.new(response[:headers][:link], response[:headers][:x_total_count])

			return subscriptions, metadata
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