require 'json'
require 'csv'

require 'rosetta/element'
require 'rosetta/json_deserializer'
require 'rosetta/csv_serializer'

class Rosetta
  class ConversionError < ArgumentError; end

  class << self
    def convert(json)
      elements = JSONDeserializer.deserialize(json)
      CSVSerializer.serialize(elements)
    end
  end
end
