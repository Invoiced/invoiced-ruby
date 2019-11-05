require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class TaskTest < Test::Unit::TestCase
    should "return the api endpoint" do
      task = Task.new(@client, "test")
      assert_equal('/tasks/test', task.endpoint())
    end

    should "create a task" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Task"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      task = @client.Task.create({:name => "Test Task"})

      assert_instance_of(Invoiced::Task, task)
      assert_equal("test", task.id)
      assert_equal('Test Task', task.name)
    end

    should "retrieve a task" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"Test Task"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      task = @client.Task.retrieve("test")

      assert_instance_of(Invoiced::Task, task)
      assert_equal("test", task.id)
      assert_equal('Test Task', task.name)
    end

    should "not update a task when no params" do
      task = Task.new(@client, "test")
      assert_false(task.save)
    end

    should "update a task" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","name":"new contents"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      task = Task.new(@client, "test")
      task.name = "new contents"
      assert_true(task.save)

      assert_equal(task.name, 'new contents')
    end

    should "list all tasks" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","name":"Test Task"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/tasks?per_page=25&page=1>; rel="self", <https://api.invoiced.com/tasks?per_page=25&page=1>; rel="first", <https://api.invoiced.com/tasks?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      tasks, metadata = @client.Task.list

      assert_instance_of(Array, tasks)
      assert_equal(1, tasks.length)
      assert_equal("test", tasks[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a task" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      task = Task.new(@client, "test")
      assert_true(task.delete)
    end
  end
end