module Invoiced
  class Inbox < Object
    include Invoiced::Operations::List

    OBJECT_NAME = 'inbox'
  end
end