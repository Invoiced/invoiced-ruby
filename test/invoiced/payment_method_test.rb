require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class PaymentMethodTest < Test::Unit::TestCase
    include Invoiced::Operations::EndpointTest
    include Invoiced::Operations::RetrieveTest
    include Invoiced::Operations::UpdateTest
    include Invoiced::Operations::ListTest

    setup do
      @objectClass = PaymentMethod
      @endpoint = '/payment_methods'
    end
  end
end