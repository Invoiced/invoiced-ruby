require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class FileTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::CreateTest
    include Invoiced::Operations::RetrieveTest
    include Invoiced::Operations::DeleteTest

    setup do
      @objectClass = File
      @endpoint = '/files'
    end
  end
end