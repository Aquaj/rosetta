require 'rosetta/exceptions'

module Rosetta
  module Deserializers
    @registered = {}

    def self.[](key)
      @registered[key]
    end

    def self.register(name, deserializer)
      raise ExistingDeserializerError, <<-ERROR.strip if @registered.key? name
        Deserializer #{name} is already registered.
      ERROR
      @registered[name] = deserializer
    end
  end
end
