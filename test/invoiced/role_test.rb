require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class RoleTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::CreateTest
    include Invoiced::Operations::RetrieveTest
    include Invoiced::Operations::UpdateTest
    include Invoiced::Operations::DeleteTest
    include Invoiced::Operations::ListTest

    setup do
      @objectClass = Role
      @endpoint = '/roles'
    end
  end
end