module Invoiced
  class InvoiceChasingCadence < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'invoice_chasing_cadence'
  end
end