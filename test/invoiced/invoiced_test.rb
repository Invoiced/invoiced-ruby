require 'invoiced'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'

module Invoiced
  class InvoicedTest < Test::Unit::TestCase
  	should "create new client" do
  		client = Invoiced::Client.new('api_key')
  		assert_equal('api_key', client.api_key)
      assert_equal('https://api.invoiced.com', client.api_url)
  	end

    should "create new sandbox client" do
      client = Invoiced::Client.new('api_key', true)
      assert_equal('api_key', client.api_key)
      assert_equal('https://api.sandbox.invoiced.com', client.api_url)
    end

  	should "perform a get request" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"test":true}')
      mockResponse.stubs(:headers).returns(:Header => "test")

      # not used
      # expectedParameters = {
      #   :method => "GET",
      #   :url => "https://api.invoiced.com/invoices?test=property&filter[levels]=work",
      #   :headers => {
      #     :authorization => "Basic dGVzdDo=",
      #     :content_type => "application/json",
      #     :user_agent => "Invoiced Ruby/#{Invoiced::VERSION}"
      #   },
      #   :payload => nil
      # }

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

  		client = Invoiced::Client.new('test')
  		params = {
  			"test" => "property",
  			"filter" => {
  				"levels" => "work"
  			}
  		}
  		response = client.request("GET", "/invoices", params)

      expectedResponse = {
        :code => 200,
        :headers => {
          :Header => "test"
        },
        :body => {
          :test => true
        }
      }
      assert_equal(expectedResponse, response)
  	end

    should "perform a post request" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:headers).returns(:Header => "test")

      # not used
      # expectedParameters = {
      #   :method => "POST",
      #   :url => "https://api.invoiced.com/invoices?test=property&filter[levels]=work",
      #   :headers => {
      #     :authorization => "Basic dGVzdDo=",
      #     :content_type => "application/json",
      #     :user_agent => "Invoiced Ruby/#{Invoiced::VERSION}"
      #   },
      #   :payload => '{"test":"property"}'
      # }

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      client = Invoiced::Client.new('test')
      params = {
        "test" => "property"
      }
      response = client.request("POST", "/invoices", params)

      expectedResponse = {
        :code => 204,
        :headers => {
          :Header => "test"
        },
        :body => nil
      }
      assert_equal(expectedResponse, response)
    end

    should "perform an idempotent post request" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:headers).returns({})

      # not used
      # expectedParameters = {
      #   :method => "POST",
      #   :url => "https://api.invoiced.com/invoices?test=property&filter[levels]=work",
      #   :headers => {
      #     :authorization => "Basic dGVzdDo=",
      #     :content_type => "application/json",
      #     :user_agent => "Invoiced Ruby/#{Invoiced::VERSION}"
      #     :idempotency_key => "a random value"
      #   },
      #   :payload => '{"test":"property"}'
      # }

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      client = Invoiced::Client.new('test')
      params = {
        "test" => "property"
      }
      response = client.request("POST", "/invoices", params, {:idempotency_key => "a random value"})

      expectedResponse = {
        :code => 204,
        :headers => {},
        :body => nil
      }
      assert_equal(expectedResponse, response)
    end

    should "handle a generic network error" do
      RestClient::Request.any_instance.expects(:execute).raises(RestClient::Exception.new)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::ApiConnectionError do
        client.request("POST", "/invoices")
      end
    end

    should "handle an invalid SSL certificate" do
      RestClient::Request.any_instance.expects(:execute).raises(RestClient::SSLCertificateNotVerified.new('invalid ssl cert'))

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::ApiConnectionError do
        client.request("POST", "/invoices")
      end
    end

    should "handle a connection timeout" do
      RestClient::Request.any_instance.expects(:execute).raises(RestClient::Exceptions::OpenTimeout.new)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::ApiConnectionError do
        client.request("POST", "/invoices")
      end
    end

    should "handle a read timeout" do
      RestClient::Request.any_instance.expects(:execute).raises(RestClient::Exceptions::ReadTimeout.new)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::ApiConnectionError do
        client.request("POST", "/invoices")
      end
    end

    should "handle an unfinished request" do
      RestClient::Request.any_instance.expects(:execute).raises(RestClient::ServerBrokeConnection.new)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::ApiConnectionError do
        client.request("POST", "/invoices")
      end
    end

    should "handle an invalid request error" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(400)
      mockResponse.stubs(:body).returns('{"error":true}')

      ex = RestClient::ExceptionWithResponse.new
      ex.response = mockResponse

      RestClient::Request.any_instance.expects(:execute).raises(ex)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::InvalidRequestError do
        client.request("POST", "/invoices")
      end
    end

    should "handle an authentication error" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(401)
      mockResponse.stubs(:body).returns('{"error":true}')

      ex = RestClient::ExceptionWithResponse.new
      ex.response = mockResponse

      RestClient::Request.any_instance.expects(:execute).raises(ex)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::AuthenticationError do
        client.request("POST", "/invoices")
      end
    end

    should "handle a rate limit error" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(429)
      mockResponse.stubs(:body).returns('{"error":true}')

      ex = RestClient::ExceptionWithResponse.new
      ex.response = mockResponse

      RestClient::Request.any_instance.expects(:execute).raises(ex)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::RateLimitError do
        client.request("POST", "/invoices")
      end
    end

    should "handle an api error" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(500)
      mockResponse.stubs(:body).returns('{"error":true}')

      ex = RestClient::ExceptionWithResponse.new
      ex.response = mockResponse

      RestClient::Request.any_instance.expects(:execute).raises(ex)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::ApiError do
        client.request("POST", "/invoices")
      end
    end

    should "handle an api error with invalid json" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(500)
      mockResponse.stubs(:body).returns('not valid json')

      ex = RestClient::ExceptionWithResponse.new
      ex.response = mockResponse

      RestClient::Request.any_instance.expects(:execute).raises(ex)

      client = Invoiced::Client.new('test')

      assert_raise Invoiced::ApiError do
        client.request("POST", "/invoices")
      end
    end

    should "generate a single sign-on token" do
        ssoKey = '8baa4dbc338a54bbf7696eef3ee4aa2daadd61bba85fcfe8df96c7cfa227c43'
        client = Invoiced::Client.new('API_KEY', false, ssoKey)
        t = Time.now
        
        token = client.generate_sign_in_token(1234, 3600)
        
        decrypted = JWT.decode token, ssoKey, true, { :algorithm => 'HS256' }
        assert_operator decrypted[0]['exp'] - t.to_i - 3600, :<, 3 # this accounts for slow running tests
        decrypted[0].delete('exp')

        expected = {
            'iat' => t.to_i,
            'sub' => 1234,
            'iss' => 'Invoiced Ruby/'+Invoiced::VERSION
        }
        assert_equal(expected, decrypted[0])
    end

    should "raise an error when generating a single sign-on token with no key" do
      client = Invoiced::Client.new('test')
      assert_raise do
        client.generate_sign_in_token(1234, 3600)
      end
    end
  end
end
