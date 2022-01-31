module Invoiced
  class CustomerChasingCadence < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'customer_chasing_cadence'
  end
end