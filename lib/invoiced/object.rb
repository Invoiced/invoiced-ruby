module Invoiced
	class Object
		def initialize(id=nil)
			@id = id
			@values = Set.new
			@unsaved = Set.new
		end

	    def to_s(*args)
	    	JSON.pretty_generate(@values)
	    end

	    def [](k)
	    	@values[k.to_sym]
	    end

	    def []=(k, v)
	    	send(:"#{k}=", v)
	    end

	    def keys
	    	@values.keys
	    end

	    def values
	    	@values.values
	    end

	    def to_json(*a)
	    	JSON.generate(@values)
	    end

	    def as_json(*a)
	    	@values.as_json(*a)
	    end

	    def to_hash
	    	@values.inject({}) do |acc, (key, value)|
	        	acc[key] = value.respond_to?(:to_hash) ? value.to_hash : value
	        	acc
	    	end
	    end

	    def each(&blk)
	    	@values.each(&blk)
	    end
	end
end