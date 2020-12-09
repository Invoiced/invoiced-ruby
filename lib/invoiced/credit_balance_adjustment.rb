module Invoiced
    class CreditBalanceAdjustment < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete

        OBJECT_NAME = 'credit_balance_adjustment'
    end
end