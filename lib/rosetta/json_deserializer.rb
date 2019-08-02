class Rosetta
  class JSONDeserializer
    def self.deserialize(input)
      new(input).deserialize
    end

    attr_reader :input

    def initialize(input)
      @input = input.dup.freeze
    end

    def deserialize
      validate_input!
      input.map { |obj| Element.new(obj) }
    end

    private

      def validate_input!
        raise ConversionError, <<-ERROR.strip unless parsed_input = valid_json(@input)
          JSON input is invalid
        ERROR
        raise ConversionError, <<-ERROR.strip unless parsed_input.is_a? Array
          JSON input must be an array
        ERROR
        raise ConversionError, <<-ERROR.strip unless parsed_input.all? { |o| o.is_a? Hash }
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