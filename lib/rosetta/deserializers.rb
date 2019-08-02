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
      def self.inherited(new_serializer)
        key = new_serializer.name.match(/^(.*?)(Deserializer)?$/)[1]
        key = key.split("::").last
        #NOTE: Similar to Rails's #underscore
        #TODO: Extract in refinement?
        key = key.scan(/[A-Z]+[a-z]*/).join('_').downcase.to_sym
        Deserializers.register(key, new_serializer)
      end
    end
  end
end
