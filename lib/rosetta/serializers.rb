require 'rosetta/exceptions'
require 'rosetta/support/registerable'

module Rosetta
  module Serializers
    extend Support::Registerable
    registerable_as :serializer
  end
end
