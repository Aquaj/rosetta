class Rosetta
  class Element
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def headers
      headers_of(object)
    end

    # Similar to #dig method
    def [](key)
      key.split(".").reduce(object) { |hash, step| hash[step] if hash }
    end

    private

      def headers_of(obj)
        obj.flat_map do |key, val|
          case val
          when Hash
            headers_of(val).map{ |header| [key, header].join('.') }
          else
            key
          end
        end
      end
  end
end
