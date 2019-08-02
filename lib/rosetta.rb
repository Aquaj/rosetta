require 'rosetta/json_deserializer'
require 'rosetta/csv_serializer'

class Rosetta

  class << self
    def convert(input)
      elements = JSONDeserializer.deserialize(input)
      CSVSerializer.serialize(elements)
    end
  end
end
