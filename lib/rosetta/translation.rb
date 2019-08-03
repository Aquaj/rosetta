require 'rosetta/exceptions'

class Rosetta
  class Translation
    @registered = {}

    attr_reader :serializer, :deserializer, :translator
    alias_method :translator?, :translator

    def self.register(source, destination, callable = nil, &block)
      raise ExistingTranslatorError, <<-ERROR.strip if @registered.key? name
        There already is a translator from #{source} to #{destination}.
      ERROR

      raise ArgumentError, "Can't take both callabel object and block." if callable && block
      @registered[source => destination] = callable || block
    end

    def self.[](key)
      @registered[key]
    end

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
