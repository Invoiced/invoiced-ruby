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

            response[:body]
        end
    end
end