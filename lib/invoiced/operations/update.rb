require "logger"

module Invoiced
    module Operations
        module Update
            def save(params={}, opts={})
                logger = Logger.new(STDOUT)

                update = {}

                @unsaved.each do |k|
                    update[k] = @values[k]
                end

                update = update.merge(params)

                logger.info("\n\n\n\n\n\n\n\n")
                logger.info("In invoiced gem")
                logger.info("the params passed in = #{params.inspect}")
                logger.info("the opts passed in = #{opts.inspect}")
                logger.info("@unsaved = #{@unsaved.inspect}")

                # perform the update if there are any changes
                if update.length > 0
                    response = @client.request(:patch, self.endpoint(), update, opts)
                    logger.info("request has been made")
                    logger.info("response = #{response.inspect}")

                    # update the local values with the response
                    refresh_from(response[:body].dup.merge({:id => self.id}))

                    return response[:code] == 200
                end

                logger.info("\n\n\n\n\n\n\n\n")

                false
            end
        end
    end
end
