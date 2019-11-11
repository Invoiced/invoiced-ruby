module Invoiced
    class Invoice < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'invoice'

        def send(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/emails", params, opts)

            # build email objects
            email = Email.new(@client)
            Util.build_objects(email, response[:body])
        end

        def send_sms(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/text_messages", params, opts)

            # build text message objects
            text_message = TextMessage.new(@client)
            Util.build_objects(text_message, response[:body])
        end

        def send_letter(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/letters", params, opts)

            # build letter objects

            letter = Letter.new(@client)
            Util.build_objects(letter, response[:body])
        end

        def pay(opts={})
            response = @client.request(:post, "#{self.endpoint()}/pay", {}, opts)

            # update the local values with the response
            refresh_from(response[:body].dup.merge({:id => self.id}))

            return response[:code] == 200
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

        def payment_plan()
            paymentPlan = PaymentPlan.new(@client)
            paymentPlan.set_endpoint_base(self.endpoint())
        end

        def notes()
            note = Note.new(@client)
            note.set_endpoint_base(self.endpoint())
        end

        def void()
            response = @client.request(:post, "#{self.endpoint()}/void", {})

            refresh_from(response[:body].dup.merge({:id => self.id}))

            return response[:code] == 200
        end
    end
end