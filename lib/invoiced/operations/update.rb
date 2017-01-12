module Invoiced
    module Operations
        module Update
            def save(params = {})
                update = {}

                @unsaved.each do |k|
                    update[k] = @values[k]
                end

                update.merge(params)

                # perform the update if there are any changes
                if update.length > 0
                    response = @client.request(:patch, self.endpoint(), update)

                    # update the local values with the response
                    refresh_from(response[:body].dup.merge({:id => self.id}))

                    return response[:code] == 200
                end

                false
            end
        end
    end
end