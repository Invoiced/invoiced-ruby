require 'rest-client'
require 'json'
require 'base64'

require 'invoiced/version'
require 'invoiced/invoice'

module Invoiced
	class Client
		ApiBase = 'https://api.invoiced.com'

	    def initialize(api_key)
	      @api_key = api_key
	    end

	    def request(method, endpoint, params={})
	    	url = ApiBase + endpoint + '?envelope=0'

			case method.to_s.downcase.to_sym
			# Convert params into query parameters
			when :get, :head, :delete
				url += "#{URI.parse(url).query ? '&' : '?'}#{self.uri_encode(params)}" if params && params.any?
				payload = nil
			else
				payload = params.to_json
			end

	    	response = RestClient::Request.execute(
	    		method: method,
	    		url: url,
	    		headers: {
	    			:authorization => auth_header,
	    			:content_type => "application/json",
	    			:user_agent => "Invoiced Ruby/#{Invoiced::VERSION}",
	    			# pass in query parameters here
	    			# due to an eccentricity in the rest-client gem
	    			:params => params
	    		},
	    		payload: payload
	    	)

	    	JSON.parse(response.body)
	    end

	    def Invoice
	    	Invoice.new(self)
	    end

	    private

	    def auth_header
	    	"Basic " + Base64.strict_encode64(@api_key + ":")
	    end

		def self.uri_encode(params)
			if params.is_a?(Hash)
				params.map {
					|k,v| "#{k}=#{self.uri_encode(v)}"
				}.join('&')
			else
				URI.escape(params.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
			end
		end
	end
end