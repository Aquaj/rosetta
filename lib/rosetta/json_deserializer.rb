require 'json'

require 'rosetta/element'
require 'rosetta/exceptions'
require 'rosetta/deserializers'

module Rosetta
  class JSONDeserializer < Deserializers::Base
    def call
      validate_input!
      input.map { |obj| Element.new(obj) }
    end

    private

      def validate_input!
        raise DeserializationError, <<-ERROR.strip unless parsed_input = valid_json(@input)
          JSON input is invalid
        ERROR
        raise DeserializationError, <<-ERROR.strip unless parsed_input.is_a? Array
          JSON input must be an array
        ERROR
        raise DeserializationError, <<-ERROR.strip unless parsed_input.all? { |o| o.is_a? Hash }
          JSON input must contain objects
        ERROR

        @input = parsed_input.freeze
      end

      #HACK: Feels dirty but there's no JSON soft-parsing in ruby's json lib
      def valid_json(json)
        JSON(json)
      #NOTE: Rescuing TypeError too in case json is not a String
      rescue JSON::ParserError, TypeError
        nil
      end
  end
end
