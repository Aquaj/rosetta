class Rosetta
  class JSONSerializer
    class << self
      def deserialize(input)
        validate_input!(input)
      end

      private

        def validate_input!(json)
          raise ConversionError, <<-ERROR.strip unless input = valid_json(json)
            JSON input is invalid
          ERROR
          raise ConversionError, <<-ERROR.strip unless input.is_a? Array
            JSON input must be an array
          ERROR
          raise ConversionError, <<-ERROR.strip unless input.all? { |o| o.is_a? Hash }
            JSON input must contain objects
          ERROR

          inputs = input.map { |e| Element.new(e) }

          schema, *others = inputs.map(&:headers).uniq
          raise ConversionError, <<-ERROR.strip unless others.none?
            All objects in JSON array do not share the same structure
          ERROR

          [schema, input.map { |e| Element.new(e) }]
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
end
