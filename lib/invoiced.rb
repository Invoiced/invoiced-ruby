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
require 'invoiced/error/rate_limit_error'
require 'invoiced/list'
require 'invoiced/operations/list'
require 'invoiced/operations/create'
require 'invoiced/operations/delete'
require 'invoiced/operations/update'

require 'invoiced/object'
require 'invoiced/attachment'
require 'invoiced/catalog_item'
require 'invoiced/contact'
require 'invoiced/credit_note'
require 'invoiced/customer'
require 'invoiced/email'
require 'invoiced/estimate'
require 'invoiced/event'
require 'invoiced/file'
require 'invoiced/invoice'
require 'invoiced/line_item'
require 'invoiced/payment_plan'
require 'invoiced/plan'
require 'invoiced/subscription'
require 'invoiced/transaction'

module Invoiced
    class Client
        ApiBase = 'https://api.invoiced.com'
        ApiBaseSandbox = 'https://api.sandbox.invoiced.com'

        OpenTimeout = 30
        ReadTimeout = 80

        attr_reader :api_key, :api_url, :sandbox
        attr_reader :CatalogItem, :CreditNote, :Customer, :Estimate, :Event, :File, :Invoice, :Plan, :Subscription, :Transaction

        def initialize(api_key, sandbox=false)
          @api_key = api_key
          @sandbox = sandbox
          @api_url = sandbox ? ApiBaseSandbox : ApiBase

          # Object endpoints
          @CatalogItem = Invoiced::CatalogItem.new(self)
          @CreditNote = Invoiced::CreditNote.new(self)
          @Customer = Invoiced::Customer.new(self)
          @Estimate = Invoiced::Estimate.new(self)
          @Event = Invoiced::Event.new(self)
          @File = Invoiced::File.new(self)
          @Invoice = Invoiced::Invoice.new(self)
          @Plan = Invoiced::Plan.new(self)
          @Subscription = Invoiced::Subscription.new(self)
          @Transaction = Invoiced::Transaction.new(self)
        end

        def request(method, endpoint, params={}, opts={})
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
                    :headers => buildHeaders(opts),
                    :payload => payload,
                    :open_timeout => OpenTimeout,
                    :timeout => ReadTimeout
                )
            rescue RestClient::Exception => e
                if e.response
                    handle_api_error(e.response)
                else
                    handle_network_error(e)
                end
            end

            parse(response)
        end

        private

        def buildHeaders(opts)
            headers = {
                :authorization => Util.auth_header(@api_key),
                :content_type => "application/json",
                :user_agent => "Invoiced Ruby/#{Invoiced::VERSION}"
            }

            # idempotency keys
            if opts[:idempotency_key]
                headers[:idempotency_key] = opts[:idempotency_key]
            end

            return headers
        end

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

        def handle_api_error(response)
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
            when 429
                raise rate_limit_error(error, response)
            else
                raise api_error(error, response)
            end
        end

        def handle_network_error(error)
            case error
            when RestClient::Exceptions::OpenTimeout
                message = "Timed out while connecting to Invoiced. Please check your internet connection or status.invoiced.com for service outages."
            when RestClient::Exceptions::ReadTimeout
                message = "The request timed out reading data from the server."
            when RestClient::ServerBrokeConnection
                message = "Connection with the server was broken while receiving the response."
            when RestClient::SSLCertificateNotVerified
                message = "Failed to verify the Invoiced SSL certificate. Please verify that you have a recent version of OpenSSL installed."
            else
                message = "There was an error connecting to Invoiced: #{error.message}"
            end

            raise ApiConnectionError.new(message)
        end

        def authentication_error(error, response)
            AuthenticationError.new(error["message"], response.code, error)
        end

        def invalid_request_error(error, response)
            InvalidRequestError.new(error["message"], response.code, error)
        end

        def rate_limit_error(error, response)
            RateLimitError.new(error["message"], response.code, error)
        end

        def api_error(error, response)
            ApiError.new(error["message"], response.code, error)
        end

        def general_api_error(code, body)
            ApiError.new("API Error #{code} - #{body}", code)
        end
    end
end