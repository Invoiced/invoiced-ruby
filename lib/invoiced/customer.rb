module Invoiced
    class Customer < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'customer'

        def send_statement(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/emails", params, opts)

            # build email objects
            email = Email.new(@client)
            Util.build_objects(email, response[:body])
        end

        def send_statement_sms(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/text_messages", params, opts)

            # build text message objects
            text_message = TextMessage.new(@client)
            Util.build_objects(text_message, response[:body])
        end

        def send_statement_letter(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/letters", params, opts)

            # build letter objects
            letter = Letter.new(@client)
            Util.build_objects(letter, response[:body])
        end

        def balance
            response = @client.request(:get, "#{self.endpoint()}/balance")

            response[:body]
        end

        def contacts()
            contact = Contact.new(@client)
            contact.set_endpoint_base(self.endpoint())
        end

        def payment_sources()
            source = PaymentSource.new(@client)
            source.set_endpoint_base(self.endpoint())
        end

        def line_items()
            line = LineItem.new(@client)
            line.set_endpoint_base(self.endpoint())
        end

        def list_notes()
            note = Note.new(@client)
            note.set_endpoint_base(self.endpoint())
        end

        def invoice(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/invoices", params, opts)

            # build invoice object
            invoice = Invoice.new(@client)
            Util.convert_to_object(invoice, response[:body])
        end

        def consolidate_invoices(params={})
            response = @client.request(:post, "#{self.endpoint()}/consolidate_invoices", params)

            # build invoice object
            invoice = Invoice.new(@client)
            Util.convert_to_object(invoice, response[:body])
        end
    end
end