require 'json'
require 'csv'

class Rosetta
  class ConversionError < ArgumentError; end

  class << self
    def convert(json)
      input = valid_input_from!(json)
      headers = -> (hash) { hash.flat_map { |key, val| val.is_a?(Hash) ? headers.(val).map{|head| [key, head].join(?.) } : key } }
      content = -> (hash, key) { key.split(".").reduce(hash) { |c, k| c[k] } }
      head, *others = input.map(&headers).uniq
      if others.any?
        raise ConversionError, "All objects in JSON array do not share the same structure"
      end
      CSV.generate do |csv|
        csv << head
        input.each do |obj|
          csv << head.map { |h| c = content.(obj, h); c.is_a?(Array) ? c.join(?,) : c }
        end
      end
    end

    private

      def valid_input_from!(json)
        raise ConversionError, <<-ERROR.chomp unless input = valid_json(json)
          JSON input is invalid
        ERROR
        raise ConversionError, <<-ERROR.chomp unless input.is_a? Array
          JSON input must be an array
        ERROR
        raise ConversionError, <<-ERROR.chomp unless input.all? { |o| o.is_a? Hash }
          JSON input must contain objects
        ERROR
        input
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
