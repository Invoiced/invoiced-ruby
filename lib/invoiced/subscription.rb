module Invoiced
    class Subscription < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'subscription'

        def cancel
            delete
        end

        def preview(params={}, opts={})
            response = @client.request(:post, "/subscriptions/preview", params, opts)

            Util.convert_preview_to_object(self, response[:body])
        end
    end
end