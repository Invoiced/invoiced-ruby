require 'rest-client'
require 'jwt'
require 'json'
require 'base64'

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
require 'invoiced/payment_source_object'

require 'invoiced/attachment'
require 'invoiced/bank_account'
require 'invoiced/card'
require 'invoiced/charge'
require 'invoiced/contact'
require 'invoiced/coupon'
require 'invoiced/credit_balance_adjustment'
require 'invoiced/credit_note'
require 'invoiced/custom_field'
require 'invoiced/customer'
require 'invoiced/customer_chasing_cadence'
require 'invoiced/email'
require 'invoiced/email_template'
require 'invoiced/estimate'
require 'invoiced/event'
require 'invoiced/file'
require 'invoiced/gl_account'
require 'invoiced/inbox'
require 'invoiced/invoice'
require 'invoiced/invoice_chasing_cadence'
require 'invoiced/item'
require 'invoiced/late_fee_schedule'
require 'invoiced/letter'
require 'invoiced/line_item'
require 'invoiced/member'
require 'invoiced/merchant_account'
require 'invoiced/note'
require 'invoiced/payment'
require 'invoiced/payment_method'
require 'invoiced/payment_plan'
require 'invoiced/payment_source'
require 'invoiced/pdf_template'
require 'invoiced/plan'
require 'invoiced/refund'
require 'invoiced/report'
require 'invoiced/role'
require 'invoiced/sign_up_page'
require 'invoiced/sms_template'
require 'invoiced/subscription'
require 'invoiced/task'
require 'invoiced/tax_rate'
require 'invoiced/tax_rule'
require 'invoiced/text_message'
require 'invoiced/theme'
require 'invoiced/webhook'

module Invoiced
    class Client
        ApiBase = 'https://api.invoiced.com'
        ApiBaseSandbox = 'https://api.sandbox.invoiced.com'

        OpenTimeout = 30
        ReadTimeout = 80

        attr_reader :api_key, :api_url, :sandbox, :sso_key
        attr_reader :Charge, :Coupon, :CreditBalanceAdjustment, :CreditNote, :CustomField, :Customer, :CustomerChasingCadence, :EmailTemplate, :Estimate, :Event, :File, :GlAccount, :Inbox, :Invoice, :InvoiceChasingCadence, :Item, :LateFeeSchedule, :Member, :MerchantAccount, :Note, :Payment, :PaymentMethod, :PdfTemplate, :Plan, :Refund, :Report, :Role, :SignUpPage, :SmsTemplate, :Subscription, :Task, :TaxRate, :TaxRule, :Theme, :Webhook

        def initialize(api_key, sandbox=false, sso_key=false)
          @api_key = api_key
          @sandbox = sandbox
          @api_url = sandbox ? ApiBaseSandbox : ApiBase
          @sso_key = sso_key

          # Object endpoints
          @Charge = Invoiced::Charge.new(self)
          @Coupon = Invoiced::Coupon.new(self)
          @CreditBalanceAdjustment = Invoiced::CreditBalanceAdjustment.new(self)
          @CreditNote = Invoiced::CreditNote.new(self)
          @CustomField = Invoiced::CustomField.new(self)
          @Customer = Invoiced::Customer.new(self)
          @CustomerChasingCadence = Invoiced::CustomerChasingCadence.new(self)
          @EmailTemplate = Invoiced::EmailTemplate.new(self)
          @Estimate = Invoiced::Estimate.new(self)
          @Event = Invoiced::Event.new(self)
          @File = Invoiced::File.new(self)
          @GlAccount = Invoiced::GlAccount.new(self)
          @Inbox = Invoiced::Inbox.new(self)
          @Invoice = Invoiced::Invoice.new(self)
          @InvoiceChasingCadence = Invoiced::InvoiceChasingCadence.new(self)
          @Item = Invoiced::Item.new(self)
          @LateFeeSchedule = Invoiced::LateFeeSchedule.new(self)
          @Member = Invoiced::Member.new(self)
          @MerchantAccount = Invoiced::MerchantAccount.new(self)
          @Note = Invoiced::Note.new(self)
          @Payment = Invoiced::Payment.new(self)
          @PaymentMethod = Invoiced::PaymentMethod.new(self)
          @PdfTemplate = Invoiced::PdfTemplate.new(self)
          @Plan = Invoiced::Plan.new(self)
          @Refund = Invoiced::Refund.new(self)
          @Report = Invoiced::Report.new(self)
          @Role = Invoiced::Role.new(self)
          @SignUpPage = Invoiced::SignUpPage.new(self)
          @SmsTemplate = Invoiced::SmsTemplate.new(self)
          @Subscription = Invoiced::Subscription.new(self)
          @Task = Invoiced::Task.new(self)
          @TaxRate = Invoiced::TaxRate.new(self)
          @TaxRule = Invoiced::TaxRule.new(self)
          @Theme = Invoiced::Theme.new(self)
          @Webhook = Invoiced::Webhook.new(self)
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

        def generate_sign_in_token(customerId, ttl)
            if !@sso_key
                raise "Please provide a single sign-on key! You can find this value in Settings > Developers > Single Sign-On of the Invoiced application."
            end

            expires = Time.now + ttl # TTL should be in seconds

            payload = {
                :sub => customerId,
                :iss => "Invoiced Ruby/#{Invoiced::VERSION}",
                :iat => Time.now.to_i,
                :exp => expires.to_i
            }

            JWT.encode payload, @sso_key, 'HS256'
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
