require 'json'
require 'csv'

require 'rosetta/element'
require 'rosetta/json_serializer'

class Rosetta
  class ConversionError < ArgumentError; end

  class << self
    def convert(json)
      headers, elements = JSONSerializer.deserialize(json)

      CSV.generate do |csv|
        csv << headers
        elements.each do |element|
          csv << headers.map do |header|
            value = element[header]
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
