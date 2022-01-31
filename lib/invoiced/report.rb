module Invoiced
  class Report < Object
    include Invoiced::Operations::Create

    OBJECT_NAME = 'report'
  end
end