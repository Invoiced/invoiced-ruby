module Invoiced
  class MerchantAccount < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'merchant_account'
  end
end