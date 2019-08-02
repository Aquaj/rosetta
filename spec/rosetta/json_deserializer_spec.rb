require 'rosetta/json_deserializer'

RSpec.describe Rosetta::JSONDeserializer do
  it 'takes in JSON and returns elements' do
    deserialized = Rosetta::JSONDeserializer.deserialize(<<-JSON)
      [
        { "a": 1 },
        { "a": 2 }
      ]
    JSON
    expect(deserialized).to satisfy { |result| result.all? { |e| e.is_a? Rosetta::Element } }
  end
end
