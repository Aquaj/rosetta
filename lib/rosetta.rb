require 'json'
require 'csv'

class Rosetta
  class ConversionError < ArgumentError; end

  class << self
    def convert(json)
      raise ConversionError, "JSON input is invalid" unless j = valid_json(json)
      raise ConversionError, "JSON input must be an array" unless j.is_a? Array
      raise ConversionError, "JSON input must contain objects" unless j.all? { |o| o.is_a? Hash }
      headers = -> (hash) { hash.flat_map { |key, val| val.is_a?(Hash) ? headers.(val).map{|head| [key, head].join(?.) } : key } }
      content = -> (hash, key) { key.split(".").reduce(hash) { |c, k| c[k] } }
      head, *others = j.map(&headers).uniq
      if others.any?
        raise ConversionError, "All objects in JSON array do not share the same structure"
      end
      CSV.generate do |csv|
        csv << head
        j.each do |obj|
          csv << head.map { |h| c = content.(obj, h); c.is_a?(Array) ? c.join(?,) : c }
        end
      end
    end

    private

      def valid_json(json)
        JSON(json)
      #NOTE: Rescuing TypeError too in case json is not a String
      rescue JSON::ParserError, TypeError
        nil
      end
  end
end
