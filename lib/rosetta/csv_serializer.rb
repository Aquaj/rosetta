require 'csv'

require 'rosetta/exceptions'

class Rosetta
  class CSVSerializer
    def self.serialize(elements)
      new(elements).serialize
    end

    attr_reader :elements

    def initialize(elements)
      @elements = elements.dup.freeze
    end

    def serialize
      CSV.generate do |csv|
        csv << headers
        elements.each do |element|
          csv << headers.map { |header| serialize_value(element[header]) }
        end
      end
    end

    def headers
      heads, *others = elements.map(&:properties).uniq

      raise SerializationError, <<-ERROR.strip unless others.none?
        All objects need to share their structure to be serialized to CSV.
      ERROR

      heads
    end

    private

      def serialize_value(value)
        case value
        when Array
          value.join(',')
        else
          value
        end
      end
  end
end
