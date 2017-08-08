module Invoiced
    class Estimate < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'estimate'

        def send(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/emails", params, opts)

            # build email objects
            email = Email.new(@client)
            Util.build_objects(email, response[:body])
        end

        def generate_invoice(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/invoice", params, opts)

            # build invoice object
            invoice = Invoice.new(@client)
            Util.convert_to_object(invoice, response[:body])
        end

        def attachments(params={})
            response = @client.request(:get, "#{self.endpoint()}/attachments", params)

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