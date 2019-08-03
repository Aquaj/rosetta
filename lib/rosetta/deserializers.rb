require 'rosetta/exceptions'

module Rosetta
  module Deserializers
    @registered = {}

    class << self
      attr_reader :registered

      def [](key)
        registered[key]
      end

      def register(name, deserializer, &block)
        raise ExistingDeserializerError, <<-ERROR.strip if @registered.key? name
          Deserializer #{name} is already registered.
        ERROR

        raise ArgumentError, "Can't take both deserializer object and block." if deserializer && block
        @registered[name] = deserializer
      end
    end
  end
end
