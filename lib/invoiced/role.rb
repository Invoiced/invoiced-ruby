module Invoiced
  class Role < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'role'
  end
end