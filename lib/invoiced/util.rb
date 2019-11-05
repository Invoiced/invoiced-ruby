module Invoiced
    class Util
        class << self
            def auth_header(api_key)
                "Basic " + Base64.strict_encode64(api_key + ":")
            end

            def uri_encode(params)
                flatten_params(params).
                    map { |k,v| "#{k}=#{url_encode(v)}" }.join('&')
            end

            def build_objects(_class, objects)
                objects.map {
                    |object| convert_to_object(_class, object)
                }
            end

            def convert_to_object(_class, values)
                object = _class.class.new(_class.client, values[:id], values)
                object.set_endpoint_base(_class.endpoint_base())
            end

            def convert_preview_to_object(_class, values)
                object = _class.class.new(_class.client, -1, values)
                object.set_endpoint_base(_class.endpoint_base())
            end

            private

            def url_encode(params)
                URI.encode_www_form_component(params)
            end

            def flatten_params(params, parent_key=nil)
                result = []
                params.each do |key, value|
                    calculated_key = parent_key ? "#{parent_key}[#{url_encode(key)}]" : url_encode(key)
                    if value.is_a?(Hash)
                        result += flatten_params(value, calculated_key)
                    elsif value.is_a?(Array)
                        result += flatten_params_array(value, calculated_key)
                    else
                        result << [calculated_key, value]
                    end
                end
                result
            end

            def flatten_params_array(value, calculated_key)
                result = []
                value.each do |elem|
                    if elem.is_a?(Hash)
                        result += flatten_params(elem, "#{calculated_key}[]")
                    elsif elem.is_a?(Array)
                        result += flatten_params_array(elem, calculated_key)
                    else
                        result << ["#{calculated_key}[]", elem]
                    end
                end
                result
            end
        end
    end
end