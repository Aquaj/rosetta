class Rosetta
  class JSONSerializer
    def self.deserialize(input)
      new(input).deserialize
    end

    def initialize(input)
      @input = input
    end

    def deserialize
      validate_input!
    end

    private

      def validate_input!
        raise ConversionError, <<-ERROR.strip unless input = valid_json(@input)
          JSON input is invalid
        ERROR
        raise ConversionError, <<-ERROR.strip unless input.is_a? Array
          JSON input must be an array
        ERROR
        raise ConversionError, <<-ERROR.strip unless input.all? { |o| o.is_a? Hash }
          JSON input must contain objects
        ERROR

        input.map { |e| Element.new(e) }
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
