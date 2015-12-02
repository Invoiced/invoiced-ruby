require 'invoiced'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'

module Invoiced
  class InvoicedTest < Test::Unit::TestCase
  	should "create new client" do
  		client = Invoiced::Client.new('api_key')
  		assert_equal('api_key', client.api_key)
  	end

  	should "perform a get request" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"test":true}')
      mockResponse.stubs(:headers).returns(:Header => "test")

      # not used
      expectedParameters = {
        :method => "GET",
        :url => "https://api.invoiced.com/invoices?test=property&filter[levels]=work",
        :headers => {
          :authorization => "Basic dGVzdDo=",
          :content_type => "application/json",
          :user_agent => "Invoiced Ruby/#{Invoiced::VERSION}"
        },
        :payload => nil
      }

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
      expectedParameters = {
        :method => "POST",
        :url => "https://api.invoiced.com/invoices?test=property&filter[levels]=work",
        :headers => {
          :authorization => "Basic dGVzdDo=",
          :content_type => "application/json",
          :user_agent => "Invoiced Ruby/#{Invoiced::VERSION}"
        },
        :payload => '{"test":"property"}'
      }

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

    should "handle a request exception" do
      RestClient::Request.any_instance.expects(:execute).raises(RestClient::Exception.new)

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
  end
end