require 'rosetta/exceptions'

class Rosetta
  class Translation
    attr_reader :serializer, :deserializer

    def initialize(serializer, deserializer)
      @serializer = find_serializer(serializer)
      @deserializer = find_deserializer(deserializer)
    end

    def call(input)
      elements = deserializer.deserialize(input)
      serializer.serialize(elements)
    end

    private

      def find_serializer(name_or_object)
        is_name = name_or_object.is_a?(String) || name_or_object.is_a?(Symbol)
        object = name_or_object unless is_name
        Serializers.all[name_or_object] || object ||
          raise(UnknownSerializer, "Unknown serializer for: #{name_or_object.inspect}")
      end

      def find_deserializer(name_or_object)
        is_name = name_or_object.is_a?(String) || name_or_object.is_a?(Symbol)
        object = name_or_object unless is_name
        Deserializers.all[name_or_object] || object ||
          raise(UnknownSerializer, "Unknown serializer for: #{name_or_object.inspect}")
      end
  end
end
