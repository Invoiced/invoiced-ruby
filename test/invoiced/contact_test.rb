require File.expand_path('../../test_helper', __FILE__)

module Invoiced
  class ContactTest < Test::Unit::TestCase
    should "return the api endpoint" do
      contact = Contact.new(@client, 123)
      assert_equal('/contacts/123', contact.endpoint())
    end

    should "create a contact" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(201)
      mockResponse.stubs(:body).returns('{"id":123,"name":"Nancy"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      contact = Contact.new(@client)
      contact = contact.create({:name => "Nancy"})

      assert_instance_of(Invoiced::Contact, contact)
      assert_equal(123, contact.id)
      assert_equal("Nancy", contact.name)
    end

    should "retrieve a contact" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"name":"Nancy"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      contact = Contact.new(@client)
      contact = contact.retrieve(123)

      assert_instance_of(Invoiced::Contact, contact)
      assert_equal(123, contact.id)
      assert_equal("Nancy", contact.name)
    end

    should "not update a contact when no params" do
      contact = Contact.new(@client, 123)
      assert_false(contact.save)
    end

    should "update a contact" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('{"id":123,"name":"Nancy Drew"}')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      contact = Contact.new(@client, 123)
      contact.name = "Nancy Drew"
      assert_true(contact.save)

      assert_equal("Nancy Drew", contact.name)
    end

    should "list all contacts" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(200)
      mockResponse.stubs(:body).returns('[{"id":123,"name":"Nancy"}]')
      mockResponse.stubs(:headers).returns(:x_total_count => 15, :link => '<https://api.invoiced.com/contacts?per_page=25&page=1>; rel="self", <https://api.invoiced.com/contacts?per_page=25&page=1>; rel="first", <https://api.invoiced.com/contacts?per_page=25&page=1>; rel="last"')

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      contact = Contact.new(@client)
      contacts, metadata = contact.list

      assert_instance_of(Array, contacts)
      assert_equal(1, contacts.length)
      assert_equal(123, contacts[0].id)

      assert_instance_of(Invoiced::List, metadata)
      assert_equal(15, metadata.total_count)
    end

    should "delete a contact" do
      mockResponse = mock('RestClient::Response')
      mockResponse.stubs(:code).returns(204)
      mockResponse.stubs(:body).returns('')
      mockResponse.stubs(:headers).returns({})

      RestClient::Request.any_instance.expects(:execute).returns(mockResponse)

      contact = Contact.new(@client, 123)
      assert_true(contact.delete)
    end
  end
end