require 'json'
require 'csv'

class Rosetta
  class ConversionError < ArgumentError; end

  class << self
    def convert(json)
      head, input = valid_input_from!(json)
      CSV.generate do |csv|
        csv << head
        input.each do |obj|
          csv << head.map { |h| c = content(obj, h); c.is_a?(Array) ? c.join(?,) : c }
        end
      end
    end

    private

      def valid_input_from!(json)
        raise ConversionError, <<-ERROR.strip unless input = valid_json(json)
          JSON input is invalid
        ERROR
        raise ConversionError, <<-ERROR.strip unless input.is_a? Array
          JSON input must be an array
        ERROR
        raise ConversionError, <<-ERROR.strip unless input.all? { |o| o.is_a? Hash }
          JSON input must contain objects
        ERROR

        schema, *others = input.map { |obj| headers(obj) }.uniq
        raise ConversionError, <<-ERROR.strip unless others.none?
          All objects in JSON array do not share the same structure
        ERROR

        [schema, input]
      end

      def headers(object)
        object.flat_map do |key, val|
          case val
          when Hash
            headers(val).map{ |header| [key, header].join('.') }
          else
            key
          end
        end
      end

      # Similar to #dig method
      def content(object, key)
        key.split(".").reduce(object) { |hash, step| hash[step] if hash }
      end

      #HACK: Feels dirty but there's no JSON soft-parsing in ruby's json lib
      def valid_json(json)
        JSON(json)
      #NOTE: Rescuing TypeError too in case json is not a String
      rescue JSON::ParserError, TypeError
        nil
      end
  end
end
