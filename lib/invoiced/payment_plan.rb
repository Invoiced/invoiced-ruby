module Invoiced
    class PaymentPlan < Object
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'payment_plan'

        def initialize(client, id=nil, values={})
        	super
        	@endpoint = '/payment_plan'
        end

        def create(params={}, opts={})
            response = @client.request(:put, self.endpoint(), params, opts)

            Util.convert_to_object(self, response[:body])
        end

        def retrieve(params={})
            response = @client.request(:get, self.endpoint(), params)

            Util.convert_to_object(self, response[:body])
        end

        def cancel
            delete
        end
    end
end