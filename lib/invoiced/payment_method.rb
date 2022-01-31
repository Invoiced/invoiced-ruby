module Invoiced
  class PaymentMethod < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Update

    OBJECT_NAME = 'payment_method'
  end
end