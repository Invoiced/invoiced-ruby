module Invoiced
    class CatalogItem < Object
        include Invoiced::Operations::List
        include Invoiced::Operations::Create
        include Invoiced::Operations::Update
        include Invoiced::Operations::Delete
    end
end