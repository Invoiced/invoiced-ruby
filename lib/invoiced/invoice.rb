module Invoiced
    class Invoice < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete

        def send(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/emails", params, opts)

            # build email objects
            email = Email.new(@client)
            Util.build_objects(email, response[:body])
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
    end
end