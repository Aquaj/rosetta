require 'rosetta/translation'

class Rosetta
  class << self
    def translate(input, from:, to:)
      Translation.new(from, to).call(input)
    end
  end
end
