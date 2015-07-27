module Invoiced
    class Invoice < Object
    	def initialize(client)
    		@client = client
    	end

	    def list(opts={})
	    	@client.request('GET', '/invoices', opts)
	    end

	    def retrieve(opts={})
	    	@client.request('GET', '/invoices', opts)
	    end		    
	end
end