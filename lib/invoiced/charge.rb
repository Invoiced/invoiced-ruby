module Invoiced
    class Charge < Object
        include Invoiced::Operations::Create

        OBJECT_NAME = 'charge'
    end
end