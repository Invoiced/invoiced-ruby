require 'rest-client'
require 'json'
require 'base64'

require 'invoiced/version'
require 'invoiced/util'
require 'invoiced/error/error_base'
require 'invoiced/error/api_error'
require 'invoiced/error/authentication_error'
require 'invoiced/error/invalid_request'

require 'invoiced/invoice'
require 'invoiced/customer'

module Invoiced
	class Client
		ApiBase = 'https://api.invoiced.com'

	    def initialize(api_key)
	      @api_key = api_key
	    end

	    def api_key
	    	@api_key
	    end

	    def request(method, endpoint, params={})
	    	url = ApiBase + endpoint + '?envelope=0'

			case method.to_s.downcase.to_sym
			# Convert params into query parameters
			when :get, :head, :delete
				url += "#{URI.parse(url).query ? '&' : '?'}#{Util.uri_encode(params)}" if params && params.any?
				payload = nil
			else
				payload = params.to_json
			end

			begin
		    	response = RestClient::Request.execute(
		    		method: method,
		    		url: url,
		    		headers: {
		    			:authorization => Util.auth_header(@api_key),
		    			:content_type => "application/json",
		    			:user_agent => "Invoiced Ruby/#{Invoiced::VERSION}",
		    			# pass in query parameters here
		    			# due to an eccentricity in the rest-client gem
		    			:params => params
		    		},
		    		payload: payload
		    	)
		    rescue RestClient::Exception => e
		    	if e.response
		    		rescue_api_error(e.response)
		    	else
		    		rescue_restclient_error(e)
		    	end
		    end

	    	JSON.parse(response.body)
	    end

	    def Customer
	    	Customer.new(self)
	    end

	    def Invoice
	    	Invoice.new(self)
	    end

	    private

	    def rescue_api_error(response)
		    begin
				error = JSON.parse(response.body)
			rescue JSON::ParserError
				raise general_api_error(response.code, response.body)
			end

			case response.code
			when 400, 404
				raise invalid_request_error(error, response)
			when 401
				raise authentication_error(error, response)
			else
				raise api_error(error, response)
			end
	    end

	    def rescue_restclient_error(error)
	    	raise ApiError.new("There was an error connecting to Invoiced.")
	    end

	    def authentication_error(error, response)
	    	raise AuthenticationError.new("Unable to authenticate - #{error[:message]}")
	    end

	    def invalid_request_error(error, response)
	    	raise InvalidRequestError.new("Invalid Request - #{error[:message]}")
	    end

	    def api_error(error, response)
	    	raise ApiError.new("Invoiced API Error #{code} - #{body}")
	    end

	    def general_api_error(code, body)
	    	raise ApiError.new("API Error #{code} - #{body}")
	    end
	end
end