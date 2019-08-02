require 'csv'

require 'rosetta/exceptions'
require 'rosetta/serializers'

class Rosetta
  class CSVSerializer
    Serializers.register :csv, self

    def self.serialize(elements)
      new(elements).serialize
    end

    attr_reader :elements

    def initialize(elements)
      @elements = elements.dup.freeze
      validate_input!
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
      head, *_ = elements.map(&:properties).uniq
      head
    end

    def validate_input!
      _, *others = elements.map(&:properties).uniq

      raise SerializationError, <<-ERROR.strip unless others.none?
        All objects need to share their structure to be serialized to CSV.
      ERROR
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
