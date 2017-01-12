module Invoiced
    class File < Object
        include Invoiced::Operations::Create
        include Invoiced::Operations::Delete
    end
end