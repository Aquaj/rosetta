class Rosetta
  class ConversionError < StandardError; end
  class SerializationError < ConversionError; end
  class DeserializationError < ConversionError; end

  class RegistrationError < StandardError; end
  class ExistingTranslatorError < RegistrationError; end
  class ExistingSerializerError < RegistrationError; end
  class ExistingDeserializerError < RegistrationError; end

  class UnknownSerializer < StandardError; end
  class UnknownDeserializer < StandardError; end
end
