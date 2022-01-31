module Invoiced
  class LateFeeSchedule < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'late_fee_schedule'
  end
end