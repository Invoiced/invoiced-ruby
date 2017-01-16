module Invoiced
    class PaymentPlan < Object
        include Invoiced::Operations::Delete

        def initialize(client, id=nil, values={})
        	super
        	@endpoint = '/payment_plan'
        end

        def create(body={})
            response = @client.request(:put, self.endpoint(), body)

            Util.convert_to_object(self, response[:body])
        end

        def retrieve(opts={})
            response = @client.request(:get, self.endpoint(), opts)

            Util.convert_to_object(self, response[:body])
        end

        def cancel
            delete
        end
    end
end