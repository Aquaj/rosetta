require 'json'
require 'csv'
require 'byebug'

class Rosetta
  class << self
    def convert(json)
      j = JSON(json)
      headers = -> (hash) { hash.flat_map { |key, val| val.is_a?(Hash) ? headers.(val).map{|head| [key, head].join(?.) } : key } }
      content = -> (hash, key) { key.split(".").reduce(hash) { |c, k| c[k] } }
      head = headers.(j.first)
      CSV.generate do |csv|
        csv << head
        j.each do |obj|
          csv << head.map { |h| c = content.(obj, h); c.is_a?(Array) ? c.join(?,) : c }
        end
      end
    end
  end
end
