module Invoiced
    module Operations
        module Update
            def save(params={}, opts={})
                update = {}

                @unsaved.each do |k|
                    update[k] = @values[k]
                end

                update = update.merge(params)

                # perform the update if there are any changes
                if update.length > 0
                    response = @client.request(:patch, self.endpoint(), update, opts)

                    # update the local values with the response
                    refresh_from(response[:body].dup.merge({:id => self.id}))

                    return response[:code] == 200
                end

                false
            end
        end
    end
end
