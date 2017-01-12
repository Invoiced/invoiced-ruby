require 'rest-client'
require 'json'
require 'base64'
require 'active_support/inflector'

require 'invoiced/version'
require 'invoiced/util'
require 'invoiced/error/error_base'
require 'invoiced/error/api_connection_error'
require 'invoiced/error/api_error'
require 'invoiced/error/authentication_error'
require 'invoiced/error/invalid_request'
require 'invoiced/list'
require 'invoiced/operations/list'
require 'invoiced/operations/create'
require 'invoiced/operations/delete'
require 'invoiced/operations/update'

require 'invoiced/object'
require 'invoiced/attachment'
require 'invoiced/contact'
require 'invoiced/credit_note'
require 'invoiced/customer'
require 'invoiced/email'
require 'invoiced/estimate'
require 'invoiced/event'
require 'invoiced/file'
require 'invoiced/invoice'
require 'invoiced/line_item'
require 'invoiced/subscription'
require 'invoiced/transaction'

module Invoiced
	class Client
		ApiBase = 'https://api.invoiced.com'
		ApiBaseSandbox = 'https://api.sandbox.invoiced.com'

		attr_reader :api_key, :api_url, :sandbox
		attr_reader :CreditNote, :Customer, :Estimate, :Event, :File, :Invoice, :Subscription, :Transaction

	    def initialize(api_key, sandbox=false)
	      @api_key = api_key
	      @sandbox = sandbox
	      @api_url = sandbox ? ApiBaseSandbox : ApiBase

	      # Object endpoints
	      @CreditNote = Invoiced::CreditNote.new(self)
	      @Customer = Invoiced::Customer.new(self)
	      @Estimate = Invoiced::Estimate.new(self)
	      @Event = Invoiced::Event.new(self)
	      @File = Invoiced::File.new(self)
	      @Invoice = Invoiced::Invoice.new(self)
	      @Subscription = Invoiced::Subscription.new(self)
	      @Transaction = Invoiced::Transaction.new(self)
	    end

	    def request(method, endpoint, params={})
	    	url = @api_url + endpoint

			case method.to_s.downcase.to_sym
			# These methods don't have a request body
			when :get, :head, :delete
				# Make params into GET parameters
				url += "#{URI.parse(url).query ? '&' : '?'}#{Util.uri_encode(params)}" if params && params.any?
				payload = nil
			# Otherwise, encode request body to JSON
			else
				payload = params.to_json
			end

			begin
		    	response = RestClient::Request.execute(
		    		:method => method,
		    		:url => url,
		    		:headers => {
		    			:authorization => Util.auth_header(@api_key),
		    			:content_type => "application/json",
		    			:user_agent => "Invoiced Ruby/#{Invoiced::VERSION}"
		    		},
		    		:payload => payload
		    	)
		    rescue RestClient::Exception => e
		    	if e.response
		    		rescue_api_error(e.response)
		    	else
		    		rescue_rest_client_error(e)
		    	end
		    end

		    parse(response)
	    end

	    private

	    def parse(response)
	    	unless response.code == 204
	    		parsed_response = JSON.parse(response.body, :symbolize_names => true)
	    	else
	    		parsed_response = nil
	    	end

	    	{
	    		:code => response.code,
	    		:headers => response.headers,
	    		:body => parsed_response
	    	}
	    end

	    def rescue_api_error(response)
		    begin
				error = JSON.parse(response.body)
			rescue JSON::ParserError
				raise general_api_error(response.code, response.body)
			end

			case response.code
			when 400, 403, 404
				raise invalid_request_error(error, response)
			when 401
				raise authentication_error(error, response)
			else
				raise api_error(error, response)
			end
	    end

	    def rescue_rest_client_error(error)
	    	raise ApiConnectionError.new("There was an error connecting to Invoiced.")
	    end

	    def authentication_error(error, response)
	    	AuthenticationError.new(error["message"], response.code, error)
	    end

	    def invalid_request_error(error, response)
	    	InvalidRequestError.new(error["message"], response.code, error)
	    end

	    def api_error(error, response)
	    	ApiError.new(error["message"], response.code, error)
	    end

	    def general_api_error(code, body)
	    	ApiError.new("API Error #{code} - #{body}", code)
	    end
	end
end