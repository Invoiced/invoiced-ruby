module Invoiced
    class Event < Object
        include Invoiced::Operations::List

        OBJECT_NAME = 'event'
    end
end