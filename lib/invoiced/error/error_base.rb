module Invoiced
	class ErrorBase < StandardError
		attr_reader :message
		attr_reader :status_code
		attr_reader :error

		def initialize(message=nil, status_code=nil, error=nil)
			@message = message
			@status_code = status_code
			@error = error
		end

		def to_s
			"(#{@status_code}): #{@message}"
		end
	end
end