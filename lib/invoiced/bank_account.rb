module Invoiced
  class BankAccount < PaymentSourceObject
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'bank_account'
  end
end