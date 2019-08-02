require 'json'
require 'csv'

require 'rosetta/element'
require 'rosetta/json_serializer'

class Rosetta
  class ConversionError < ArgumentError; end

  class << self
    def convert(json)
      headers, objects = JSONSerializer.deserialize(json)

      CSV.generate do |csv|
        csv << headers
        objects.each do |object|
          csv << headers.map do |header|
            value = object[header]
            case value
            when Array
              value.join(',')
            else
              value
            end
          end
        end
      end
    end
  end
end
