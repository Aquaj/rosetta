class Rosetta
  class CSVSerializer
    class << self
      def serialize(elements, headers)
        CSV.generate do |csv|
          csv << headers
          elements.each do |element|
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
    end
  end
end
