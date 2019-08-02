class Rosetta
  class CSVSerializer
    def self.serialize(elements, headers)
      new(elements, headers).serialize
    end

    def initialize(elements, headers)
      @elements = elements
      @headers = headers
    end

    def serialize
      CSV.generate do |csv|
        csv << @headers
        @elements.each do |element|
          csv << @headers.map do |header|
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
  end
end
