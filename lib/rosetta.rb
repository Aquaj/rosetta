require 'rosetta/translation'

class Rosetta
  class << self
    def translate(input, from: :csv, to: :json)
      Translation.new(from, to).call(input)
    end
  end
end
