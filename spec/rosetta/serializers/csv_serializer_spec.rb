require 'rosetta/element'
require 'rosetta/serializers/csv'

RSpec.describe Rosetta::Serializers::CSV do
  it 'takes in Elements and returns csv' do
    elements = [
      Rosetta::Element.new('a' => 1),
      Rosetta::Element.new('a' => 2)
    ]

    serialized = Rosetta::Serializers::CSV.serialize(elements)
    expect(serialized).to eq <<~CSV
    a
    1
    2
    CSV
  end

  it 'serializes nested structures as a flat structure with point-separated keys' do
    elements = [
      Rosetta::Element.new('a' => { 'b' => 'c' }),
    ]

    serialized = Rosetta::Serializers::CSV.serialize(elements)
    expect(serialized).to eq <<~CSV
    a.b
    c
    CSV
  end

  it 'serializes array values as comma-separated values in a string' do
    elements = [
      Rosetta::Element.new('a' => [:a, :b]),
    ]

    serialized = Rosetta::Serializers::CSV.serialize(elements)
    expect(serialized).to eq <<~CSV
    a
    "a,b"
    CSV
  end

  it 'does not serialize Element with different structures' do
    elements = [
      Rosetta::Element.new('a' => 1),
      Rosetta::Element.new('b' => 2)
    ]

    expect { Rosetta::Serializers::CSV.serialize(elements) }.to(
      raise_error(Rosetta::ConversionError))
  end
end
