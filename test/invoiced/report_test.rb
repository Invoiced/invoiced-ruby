require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class ReportTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::CreateTest
    include Invoiced::Operations::RetrieveTest

    setup do
      @objectClass = Report
      @endpoint = '/reports'
    end
  end
end