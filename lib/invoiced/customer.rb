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

		def subscriptions(opts={})
			response = @client.request(:get, "#{@endpoint}/subscriptions", opts)

			# build objects
			subscription = Subscription.new(@client)
			subscriptions = Util.build_objects(subscription, response[:body])

			# store the metadata from the list operation
			metadata = Invoiced::List.new(response[:headers][:link], response[:headers][:x_total_count])

			return subscriptions, metadata
		end
	end
end