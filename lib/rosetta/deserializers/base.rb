require 'rosetta/deserializers'
require 'rosetta/exceptions'
require 'rosetta/support'

module Rosetta
  module Deserializers
    class Base
      using Rosetta::Support
      attr_reader :input

      class << self
        def inherited(new_serializer)
          key = new_serializer.name.match(/^(.*?)(Deserializer)?$/)[1]
          key = key.split("::").last
          Deserializers.register(key.underscore.to_sym, new_serializer)
        end

        def call(input)
          new(input).call
        rescue StandardError
          raise DeserializationError
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
