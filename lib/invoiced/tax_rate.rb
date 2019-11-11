module Invoiced
    class TaxRate < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'tax_rate'
    end
end