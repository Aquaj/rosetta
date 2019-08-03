require 'rosetta/exceptions'
require 'rosetta/support/registerable'

module Rosetta
  module Deserializers
    extend Support::Registerable

    registerable_as :deserializer
  end
end
