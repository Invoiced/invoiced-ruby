require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class EventTest < Test::Unit::TestCase
    should "return the api endpoint" do
      event = Event.new(@client, 123)
      assert_equal('/events/123', event.endpoint())
    end

    should "list all events" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"type":"customer.created"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/events?per_page=25&page=1>; rel="self", <https://api.invoiced.com/events?per_page=25&page=1>; rel="first", <https://api.invoiced.com/events?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      events, metadata = @client.Event.list

      assert_instance_of(Array, events)
      assert_equal(1, events.length)
      assert_instance_of(Invoiced::Event, events[0])
      assert_equal(123, events[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end
  end
end