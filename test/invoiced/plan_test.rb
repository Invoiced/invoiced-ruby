require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class PlanTest < Test::Unit::TestCase
    should "return the api endpoint" do
      plan = Plan.new(@client, "test")
      assert_equal('/plans/test', plan.endpoint())
    end

    should "create a plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Plan"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      plan = @client.Plan.create({:name => "Test Plan"})

      assert_instance_of(Invoiced::Plan, plan)
      assert_equal("test", plan.id)
      assert_equal('Test Plan', plan.name)
    end

    should "retrieve a plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Plan"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      plan = @client.Plan.retrieve("test")

      assert_instance_of(Invoiced::Plan, plan)
      assert_equal("test", plan.id)
      assert_equal('Test Plan', plan.name)
    end

    should "not update a plan when no params" do
      plan = Plan.new(@client, "test")
      assert_false(plan.save)
    end

    should "update a plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","closed":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      plan = Plan.new(@client, "test")
      plan.closed = true
      assert_true(plan.save)

      assert_true(plan.closed)
    end

    should "list all plans" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","name":"Test Plan"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/plans?per_page=25&page=1>; rel="self", <https://api.invoiced.com/plans?per_page=25&page=1>; rel="first", <https://api.invoiced.com/plans?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      plans, metadata = @client.Plan.list

      assert_instance_of(Array, plans)
      assert_equal(1, plans.length)
      assert_equal("test", plans[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a plan" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      plan = Plan.new(@client, "test")
      assert_true(plan.delete)
    end
  end
end