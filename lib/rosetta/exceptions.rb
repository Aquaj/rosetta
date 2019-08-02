class Rosetta
  class ConversionError < StandardError; end
  class SerializationError < ConversionError; end
  class DeserializationError < ConversionError; end
end
