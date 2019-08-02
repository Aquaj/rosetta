require 'rosetta/exceptions'

class Rosetta
  class Deserializers
    @registered = {}

    def self.all
      @registered
    end

    def self.register(name, deserializer)
      raise ExistingDeserializerError, <<-ERROR.strip if @registered.key? name
        Deserializer #{name} is already registered.
      ERROR
      @registered[name] = deserializer
    end

    class Base
      attr_reader :input

      def self.inherited(new_serializer)
        key = new_serializer.name.match(/^(.*?)(Deserializer)?$/)[1]
        key = key.split("::").last
        #NOTE: Similar to Rails's #underscore
        #TODO: Extract in refinement?
        key = key.scan(/[A-Z]+[a-z]*/).join('_').downcase.to_sym
        Deserializers.register(key, new_serializer)
      end

      def self.deserialize(input)
        new(input).deserialize
      end

      def initialize(input)
        @input = input.dup.freeze
      end

      def deserialize
        raise NotImplementedError
      end
    end
  end
end