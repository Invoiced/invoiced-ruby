module Invoiced
  class Card < PaymentSourceObject
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'card'
  end
end