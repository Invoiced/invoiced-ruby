module Invoiced
  class PaymentSource < Object
    include Invoiced::Operations::Create
    include Invoiced::Operations::List

    OBJECT_NAME = 'payment_source'
  end

  class BankAccount < PaymentSourceObject
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'bank_account'
  end

  class Card < PaymentSourceObject
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'card'
  end
end
