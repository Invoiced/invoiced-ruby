require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class NoteTest < Test::Unit::TestCase
    should "return the api endpoint" do
      note = Note.new(@client, "test")
      assert_equal('/notes/test', note.endpoint())
    end

    should "create a note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":"test","notes":"Test Note"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      note = @client.Note.create({:notes => "Test Note"})

      assert_instance_of(Invoiced::Note, note)
      assert_equal("test", note.id)
      assert_equal('Test Note', note.notes)
    end

    should "retrieve a note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","notes":"Test Note"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      note = @client.Note.retrieve("test")

      assert_instance_of(Invoiced::Note, note)
      assert_equal("test", note.id)
      assert_equal('Test Note', note.notes)
    end

    should "not update a note when no params" do
      note = Note.new(@client, "test")
      assert_false(note.save)
    end

    should "update a note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":"test","notes":"new contents"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      note = Note.new(@client, "test")
      note.notes = "new contents"
      assert_true(note.save)

      assert_equal(note.notes, 'new contents')
    end

    should "list all notes" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":"test","notes":"Test Note"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/notes?per_page=25&page=1>; rel="self", <https://api.invoiced.com/notes?per_page=25&page=1>; rel="first", <https://api.invoiced.com/notes?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      notes, metadata = @client.Note.list

      assert_instance_of(Array, notes)
      assert_equal(1, notes.length)
      assert_equal("test", notes[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      note = Note.new(@client, "test")
      assert_true(note.delete)
    end
  end
end