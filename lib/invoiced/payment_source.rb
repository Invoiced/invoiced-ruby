module Invoiced
    class PaymentSource < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'payment_source'

        def delete
            if object == 'card'
                @endpoint = '/cards/' + id.to_s
            end
            if object == 'bank_account'
                @endpoint = '/bank_accounts/' + id.to_s
            end

            if super
                return true
            else
                @endpoint = '/payment_sources' + id.to_s
                return false
            end
        end


    end
end