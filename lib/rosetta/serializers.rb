require 'rosetta/exceptions'

module Rosetta
  class Serializers
    @registered = {}

    def self.[](key)
      @registered[key]
    end

    def self.register(name, serializer)
      raise ExistingSerializerError, <<-ERROR.strip if @registered.key? name
        Serializer #{name} is already registered.
      ERROR
      @registered[name] = serializer
    end

    class Base
      attr_reader :elements

      class << self
        def inherited(new_serializer)
          key = new_serializer.name.match(/^(.*?)(Serializer)?$/)[1]
          key = key.split("::").last
          #NOTE: Similar to Rails's #underscore
          #TODO: Extract in refinement?
          key = key.scan(/[A-Z]+[a-z]*/).join('_').downcase.to_sym
          Serializers.register(key, new_serializer)
        end

        def call(elements)
          new(elements).call
        end
        alias_method :serialize, :call

        def to_proc
          proc { |*args, &block| self.call(*args, &block) }
        end
      end

      def initialize(elements)
        @elements = elements.dup.freeze
        validate_input!
      end

      def call
        raise NotImplementedError
      end
      alias_method :serialize, :call

      def to_proc
        proc { |*args, &block| self.call(*args, &block) }
      end
    end
  end
end
