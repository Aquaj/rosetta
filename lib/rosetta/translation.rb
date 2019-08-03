require 'rosetta/exceptions'
require 'rosetta/support/registerable'

module Rosetta
  class Translation
    extend Support::Registerable
    registerable_as :translator

    class << self
      alias_method :register_key, :register

      def register(source, destination, object=nil, &block)
        register_key({ source => destination }, object, &block)
      end
    end

    attr_reader :serializer, :deserializer, :translator
    alias_method :translator?, :translator

    def initialize(deserializer, serializer)
      @translator = Translation[deserializer => serializer]
      unless @translator
        @serializer = find_serializer(serializer)
        @deserializer = find_deserializer(deserializer)
      end
    end

    def call(input)
      if translator?
        translator.call(input)
      else
        elements = deserializer.call(input)
        serializer.call(elements)
      end
    end

    def to_proc
      proc { |*args, &block| self.call(*args, &block) }
    end

    private

      def find_serializer(name_or_object)
        is_name = name_or_object.is_a?(String) || name_or_object.is_a?(Symbol)
        object = name_or_object unless is_name
        Serializers[name_or_object] || object ||
          raise(UnknownSerializer, "Unknown serializer for: #{name_or_object.inspect}")
      end

      def find_deserializer(name_or_object)
        is_name = name_or_object.is_a?(String) || name_or_object.is_a?(Symbol)
        object = name_or_object unless is_name
        Deserializers[name_or_object] || object ||
          raise(UnknownSerializer, "Unknown serializer for: #{name_or_object.inspect}")
      end
  end
end
