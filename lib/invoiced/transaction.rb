module Invoiced
    class Transaction < Object
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

        def refund(opts={})
            response = @client.request(:post, "#{self.endpoint()}/refunds", opts)

            Util.convert_to_object(self, response[:body])
        end
    end
end