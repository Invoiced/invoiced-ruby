module Invoiced
  class SignUpPage < Object
    include Invoiced::Operations::List
    include Invoiced::Operations::Create
    include Invoiced::Operations::Update
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'sign_up_page'
  end
end