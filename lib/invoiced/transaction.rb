module Invoiced
    class Transaction < Object
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

        def refund(params={}, opts={})
            response = @client.request(:post, "#{self.endpoint()}/refunds", params, opts)

            Util.convert_to_object(self, response[:body])
        end
    end
end