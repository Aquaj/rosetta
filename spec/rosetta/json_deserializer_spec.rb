require 'rosetta/json_deserializer'

RSpec.describe Rosetta::JSONDeserializer do
  it 'takes in JSON and returns elements' do
    deserialized = Rosetta::JSONDeserializer.deserialize(<<-JSON)
      [
        { "a": 1 },
        { "a": 2 }
      ]
    JSON
    expect(deserialized.length).to be 2
    expect(deserialized).to satisfy { |result| result.all? { |e| e.is_a? Rosetta::Element } }
  end

  it 'raises if passed invalid JSON as an input' do
    input = File.read(file_fixture('users.json'))
    input = input[0..-10] # Incomplete file
    expect { Rosetta::JSONDeserializer.deserialize(input) }.to(
      raise_error(Rosetta::DeserializationError))
  end

  it 'handles JSON arrays of objects only' do
    non_objects = <<-JSON
      [
        ["a", 1]
      ]
    JSON
    expect { Rosetta::JSONDeserializer.deserialize(non_objects) }.to(
      raise_error(Rosetta::DeserializationError))

    non_array = <<-JSON
    {
      "object": { "a": 1 }
    }
    JSON
    expect { Rosetta::JSONDeserializer.deserialize(non_array) }.to(
      raise_error(Rosetta::DeserializationError))
  end
end
