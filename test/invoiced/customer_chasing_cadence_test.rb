require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class CustomerChasingCadenceTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::CreateTest
    include Invoiced::Operations::RetrieveTest
    include Invoiced::Operations::UpdateTest
    include Invoiced::Operations::DeleteTest
    include Invoiced::Operations::ListTest

    setup do
      @objectClass = CustomerChasingCadence
      @endpoint = '/customer_chasing_cadences'
    end
  end
end