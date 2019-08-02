require 'rosetta/exceptions'

class Rosetta
  class Serializers
    @registered = {}

    def self.all
      @registered
    end

    def self.register(name, serializer)
      raise ExistingSerializerError, <<-ERROR.strip if @registered.key? name
        Serializer #{name} is already registered.
      ERROR
      @registered[name] = serializer
    end
  end
end
