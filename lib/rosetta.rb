require 'json'
require 'csv'

require 'rosetta/element'
require 'rosetta/json_serializer'
require 'rosetta/csv_serializer'

class Rosetta
  class ConversionError < ArgumentError; end

  class << self
    def convert(json)
      elements = JSONSerializer.deserialize(json)
      CSVSerializer.serialize(elements)
    end
  end
end
