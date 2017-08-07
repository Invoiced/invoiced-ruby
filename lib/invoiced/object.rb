module Invoiced
    class Object
        include Enumerable

        attr_reader :client

         @@permanent_attributes = Set.new([:id])

        def initialize(client, id=nil, values={})
            @client = client
            @endpoint_base = ''
            @endpoint = build_endpoint
            @id = id
            @values = {}

            if !id.nil?
                @endpoint += "/#{id}"
                @unsaved = Set.new
                refresh_from(values.dup.merge({:id => id}))
            end
        end

        def set_endpoint_base(base)
            @endpoint_base = base
            self
        end

        def endpoint_base()
            @endpoint_base
        end

        def endpoint()
            @endpoint_base + @endpoint
        end

        def build_endpoint
            if self.class.const_defined? "OBJECT_NAME"
                '/' + self.class::OBJECT_NAME + 's'
            else
                '/objects'
            end
        end

        def retrieve(id, params={})
            if !id
                raise ArgumentError.new("Missing ID.")
            end

            response = @client.request(:get, "#{self.endpoint()}/#{id}", params)

            Util.convert_to_object(self, response[:body])
        end

        def to_s(*args)
            JSON.pretty_generate(@values)
        end

        def inspect
            id_string = (!@id.nil?) ? " id=#{@id}" : ""
            "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(@values)
        end

        def refresh_from(values)
            removed = Set.new(@values.keys - values.keys)
            added = Set.new(values.keys - @values.keys)

            instance_eval do
                remove_accessors(removed)
                add_accessors(added)
            end
            removed.each do |k|
                @values.delete(k)
                @unsaved.delete(k)
            end
            values.each do |k, v|
                @values[k] = v
                @unsaved.delete(k)
            end

            return self
        end

        def [](k)
            @values[k.to_sym]
        end

        def []=(k, v)
            send(:"#{k}=", v)
        end

        def keys
            @values.keys
        end

        def values
            @values.values
        end

        def to_json(*a)
            JSON.generate(@values)
        end

        def to_hash
            @values.inject({}) do |acc, (key, value)|
                acc[key] = value.respond_to?(:to_hash) ? value.to_hash : value
                acc
            end
        end

        def each(&blk)
            @values.each(&blk)
        end

        def metaclass
            class << self; self; end
        end

        def remove_accessors(keys)
            metaclass.instance_eval do
                keys.each do |k|
                    next if @@permanent_attributes.include?(k)
                    k_eq = :"#{k}="
                    remove_method(k) if method_defined?(k)
                    remove_method(k_eq) if method_defined?(k_eq)
                end
            end
        end

        def add_accessors(keys)
            metaclass.instance_eval do
                keys.each do |k|
                    next if @@permanent_attributes.include?(k)
                    k_eq = :"#{k}="
                    define_method(k) { @values[k] }
                    define_method(k_eq) do |v|
                        if v == ""
                            raise ArgumentError.new(
                                "You cannot set #{k} to an empty string." \
                                "We interpret empty strings as nil in requests." \
                                "You may set #{self}.#{k} = nil to delete the property.")
                        end
                        @values[k] = v
                        @unsaved.add(k)
                    end
                end
            end
        end

        def method_missing(name, *args)
            if name.to_s.end_with?('=')
                attr = name.to_s[0...-1].to_sym
                add_accessors([attr])
                begin
                    mth = method(name)
                rescue NameError
                    raise NoMethodError.new("Cannot set #{attr} on this object. HINT: you can't set: #{@@permanent_attributes.to_a.join(', ')}")
                end
                return mth.call(args[0])
            else
                return @values[name] if @values.has_key?(name)
            end

            begin
                super
            rescue NoMethodError => e
                raise e
            end
        end
    end
end