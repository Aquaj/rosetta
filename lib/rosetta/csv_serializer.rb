class Rosetta
  class CSVSerializer
    def self.serialize(elements)
      new(elements).serialize
    end

    def initialize(elements)
      @elements = elements
    end

    def serialize
      CSV.generate do |csv|
        csv << headers
        @elements.each do |element|
          csv << headers.map do |header|
            value = element[header]
            case value
            when Array
              value.join(',')
            else
              value
            end
          end
        end
      end
    end

    def headers
      heads, *others = @elements.map(&:headers).uniq

      raise ConversionError, <<-ERROR.strip unless others.none?
        All objects need to share their structure to be serialized to CSV.
      ERROR

      heads
    end
  end
end
