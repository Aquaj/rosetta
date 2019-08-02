require 'rosetta/element'
require 'rosetta/csv_serializer'

RSpec.describe Rosetta::CSVSerializer do
  it 'takes in Elements and returns csv' do
    elements = [
      Rosetta::Element.new('a' => 1),
      Rosetta::Element.new('a' => 2)
    ]

    serialized = Rosetta::CSVSerializer.serialize(elements)
    expect(serialized).to eq <<~CSV
    a
    1
    2
    CSV
  end
end
