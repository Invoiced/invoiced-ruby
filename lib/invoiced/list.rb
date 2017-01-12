module Invoiced
    class List
        attr_reader :links
        attr_reader :total_count

        def initialize(link_header, total_count)
            @links = parse_link_header(link_header)
            @total_count = total_count
        end

        private

        def parse_link_header(header)
            links = Hash.new

            # Parse each part into a named link
            header.split(',').each do |part, index|
                section = part.split(';')
                url = section[0][/<(.*)>/,1]
                name = section[1][/rel="(.*)"/,1].to_sym
                links[name] = url
            end

            return links
        end
    end
end