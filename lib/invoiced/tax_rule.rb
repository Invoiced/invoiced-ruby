module Invoiced
  class TaxRule < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'tax_rule'
  end
end