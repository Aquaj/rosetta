class Rosetta
  class Element
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def properties
      properties_of(object)
    end

    def [](key)
      object.dig(*key.split("."))
    end

    private

      def properties_of(obj)
        obj.flat_map do |key, val|
          case val
          when Hash
            properties_of(val).map{ |header| [key, header].join('.') }
          else
            key
          end
        end
      end
  end
end
