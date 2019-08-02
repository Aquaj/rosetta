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

    class Base
      def self.inherited(new_serializer)
        key = new_serializer.name.match(/^(.*?)(Serializer)?$/)[1]
        key = key.split("::").last
        #NOTE: Similar to Rails's #underscore
        #TODO: Extract in refinement?
        key = key.scan(/[A-Z]+[a-z]*/).join('_').downcase.to_sym
        Serializers.register(key, new_serializer)
      end
    end
  end
end
