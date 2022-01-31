require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class EventTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::RetrieveTest
    include Invoiced::Operations::ListTest

    setup do
      @objectClass = Event
      @endpoint = '/events'
    end
  end
end