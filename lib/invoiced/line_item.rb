module Invoiced
    class LineItem < Object
		include Invoiced::Operations::List
		include Invoiced::Operations::Create
		include Invoiced::Operations::Update
		include Invoiced::Operations::Delete

		def initialize(client, id=nil, values={}, customer=nil)
			super(client, id, values)

			@customer = customer
			if !customer.nil?
				@endpoint = "/customers/#{customer.id}#{@endpoint}"
			end
		end
	end
end