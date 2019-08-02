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
  end
end
