require 'rosetta/serializers'
require 'rosetta/exceptions'
require 'rosetta/support'

module Rosetta
  module Serializers
    class Base
      attr_reader :elements

      class << self
        using Rosetta::Support

        def inherited(new_serializer)
          key = new_serializer.name.match(/^(.*?)(Serializer)?$/)[1]
          key = key.split("::").last
          Serializers.register(key.underscore.to_sym, new_serializer)
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
