# frozen_string_literal: true
module Invoiced
  class PaymentSource < Object
    include Invoiced::Operations::List

    OBJECT_NAME = 'payment_source'

    def list(params = {})
      response = @client.request(:get, endpoint, params)

      output = []

      response[:body].each do |obj|
        if obj[:object] == 'card'
          output.push(Util.convert_to_object(@client, Invoiced::Card, obj, self))
        end
        if obj[:object] == 'bank_account'
          output.push(Util.convert_to_object(@client, Invoiced::BankAccount, obj, self))
        end
      end

      # store the metadata from the list operation
      metadata = Invoiced::List.new(response[:headers][:link], response[:headers][:x_total_count])

      [output, metadata]
    end
  end

  class BankAccount < Object
    include Invoiced::Operations::Create
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'bank_account'

    def create(body = {}, opts = {})
      body['method'] = 'bank_account'

      # change endpoint just for this operation
      @endpoint = '/payment_sources'
      output = super
      @endpoint = '/bank_accounts'

      @endpoint = @endpoint + '/' + @id.to_s if @id

      output
    end
  end

  class Card < Object
    include Invoiced::Operations::Create
    include Invoiced::Operations::Delete

    OBJECT_NAME = 'card'

    def create(body = {}, opts = {})
      body['method'] = 'card'

      # change endpoint just for this operation
      @endpoint = '/payment_sources'
      output = super
      @endpoint = '/cards'

      @endpoint = @endpoint + '/' + @id.to_s if @id

      output
    end
  end
end
