require 'rosetta/exceptions'

module Rosetta
  module Serializers
    @registered = {}

    class << self
      attr_reader :registered

      def [](key)
        @registered[key]
      end

      def register(name, serializer)
        raise ExistingSerializerError, <<-ERROR.strip if @registered.key? name
          Serializer #{name} is already registered.
        ERROR
        @registered[name] = serializer
      end
    end
  end
end
