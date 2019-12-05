module Invoiced
  class PaymentSource < Object
    include Invoiced::Operations::Create
    include Invoiced::Operations::List

    OBJECT_NAME = 'payment_source'
  end
end
