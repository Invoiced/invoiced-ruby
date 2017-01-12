module Invoiced
    class CreditNote < Object
		include Invoiced::Operations::List
		include Invoiced::Operations::Create
		include Invoiced::Operations::Update
		include Invoiced::Operations::Delete

		def send(opts={})
			response = @client.request(:post, "#{self.endpoint()}/emails", opts)

			# build email objects
			email = Email.new(@client)
			Util.build_objects(email, response[:body])
		end

		def attachments(opts={})
			response = @client.request(:get, "#{self.endpoint()}/attachments", opts)

			# ensure each attachment has an ID
			body = response[:body]
			body.each do |attachment|
				if !attachment.has_key?(:id)
					attachment[:id] = attachment[:file][:id]
				end
			end

			# build objects
			attachment = Attachment.new(@client)
			attachments = Util.build_objects(attachment, body)

			# store the metadata from the list operation
			metadata = Invoiced::List.new(response[:headers][:link], response[:headers][:x_total_count])

			return attachments, metadata
		end
	end
end