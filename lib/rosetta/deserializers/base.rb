require 'rosetta/deserializers'
require 'rosetta/exceptions'

module Rosetta
  module Deserializers
    class Base
      attr_reader :input

      class << self
        def inherited(new_serializer)
          key = new_serializer.name.match(/^(.*?)(Deserializer)?$/)[1]
          key = key.split("::").last
          #NOTE: Similar to Rails's #underscore
          #TODO: Extract in refinement?
          key = key.scan(/[A-Z]+[a-z]*/).join('_').downcase.to_sym
          Deserializers.register(key, new_serializer)
        end

        def call(input)
          new(input).call
        end
        alias_method :deserialize, :call

        def to_proc
          proc { |*args, &block| self.call(*args, &block) }
        end
      end

      def initialize(input)
        @input = input.dup.freeze
      end

      def call
        raise NotImplementedError
      end
      alias_method :deserialize, :call

      def to_proc
        proc { |*args, &block| self.call(*args, &block) }
      end
    end
  end
end