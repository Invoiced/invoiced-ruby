require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class InboxTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::ListTest

    setup do
      @objectClass = Inbox
      @endpoint = '/inboxes'
    end
  end
end