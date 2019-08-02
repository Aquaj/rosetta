class Rosetta
  class Translation
    attr_reader :serializer, :deserializer

    def initialize(serializer, deserializer)
      @serializer = serializer
      @deserializer = deserializer
    end

    def call(input)
      elements = deserializer.deserialize(input)
      serializer.serialize(elements)
    end
  end
end
