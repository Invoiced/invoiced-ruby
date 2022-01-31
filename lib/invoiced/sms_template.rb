module Invoiced
  class SmsTemplate < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'sms_template'
  end
end