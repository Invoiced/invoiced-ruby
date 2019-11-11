require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class CouponTest < Test::Unit::TestCase
    should "return the api endpoint" do
      coupon = Coupon.new(@client, "test")
      assert_equal('/coupons/test', coupon.endpoint())
    end

    should "create a coupon" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Coupon"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      coupon = @client.Coupon.create({:name => "Test Coupon"})

      assert_instance_of(Invoiced::Coupon, coupon)
      assert_equal("test", coupon.id)
      assert_equal('Test Coupon', coupon.name)
    end

    should "retrieve a coupon" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Coupon"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      coupon = @client.Coupon.retrieve("test")

      assert_instance_of(Invoiced::Coupon, coupon)
      assert_equal("test", coupon.id)
      assert_equal('Test Coupon', coupon.name)
    end

    should "not update a coupon when no params" do
      coupon = Coupon.new(@client, "test")
      assert_false(coupon.save)
    end

    should "update a coupon" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Testing Coupon"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      coupon = Coupon.new(@client, "test")
      coupon.name = "Testing Coupon"
      assert_true(coupon.save)

      assert_equal(coupon.name, "Testing Coupon")
    end

    should "list all coupons" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","name":"Test Coupon"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="self", <https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="first", <https://api.invoiced.com/catalog_items?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      coupons, metadata = @client.Coupon.list

      assert_instance_of(Array, coupons)
      assert_equal(1, coupons.length)
      assert_equal("test", coupons[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a coupon" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      coupon = Coupon.new(@client, "test")
      assert_true(coupon.delete)
    end
  end
end