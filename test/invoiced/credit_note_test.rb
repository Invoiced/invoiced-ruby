require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class CreditNoteTest < Test::Unit::TestCase
    should "return the api endpoint" do
      creditNote = CreditNote.new(@client, 123)
      assert_equal('/credit_notes/123', creditNote.endpoint())
    end

    should "create a credit note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"number":"CN-0001"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditNote = @client.CreditNote.create({:number => "CN-0001"})

      assert_instance_of(Invoiced::CreditNote, creditNote)
      assert_equal(123, creditNote.id)
      assert_equal('CN-0001', creditNote.number)
    end

    should "retrieve a credit note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"number":"CN-0001"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditNote = @client.CreditNote.retrieve(123)

      assert_instance_of(Invoiced::CreditNote, creditNote)
      assert_equal(123, creditNote.id)
      assert_equal('CN-0001', creditNote.number)
    end

    should "not update a credit note when no params" do
      creditNote = CreditNote.new(@client, 123)
      assert_false(creditNote.save)
    end

    should "update a credit note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"closed":true}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditNote = CreditNote.new(@client, 123)
      creditNote.closed = true
      assert_true(creditNote.save)

      assert_true(creditNote.closed)
    end

    should "list all credit notes" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"number":"CN-0001"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/credit_notes?per_page=25&page=1>; rel="self", <https://api.invoiced.com/credit_notes?per_page=25&page=1>; rel="first", <https://api.invoiced.com/credit_notes?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditNotes, metadata = @client.CreditNote.list

      assert_instance_of(Array, creditNotes)
      assert_equal(1, creditNotes.length)
      assert_equal(123, creditNotes[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a credit note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditNote = CreditNote.new(@client, 123)
      assert_true(creditNote.delete)
    end

    should "send a credit note" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('[{"id":4567,"email":"test@example.com"}]')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditNote = CreditNote.new(@client, 1234)
      emails = creditNote.send

      assert_instance_of(Array, emails)
      assert_equal(1, emails.length)
      assert_instance_of(Invoiced::Email, emails[0])
      assert_equal(4567, emails[0].id)
    end

    should "list all of the credit note's attachments" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"file":{"id":456}}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 10, :link => '<https://api.invoiced.com/credit_notes/123/attachments?per_page=25&page=1>; rel="self", <https://api.invoiced.com/credit_notes/123/attachments?per_page=25&page=1>; rel="first", <https://api.invoiced.com/credit_notes/123/attachments?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      creditNote = CreditNote.new(@client, 123)
      attachments, metadata = creditNote.attachments

      assert_instance_of(Array, attachments)
      assert_equal(1, attachments.length)
      assert_equal(456, attachments[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(10, metadata.total_count)
    end
  end
end