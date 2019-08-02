require 'rosetta/translation'

require 'rosetta/csv_serializer'
require 'rosetta/json_deserializer'

RSpec.describe Rosetta::Translation do
  it 'can convert from one format to another using a given serializer and deserializer' do
    input = File.read(file_fixture('users.json'))
    output = File.read(file_fixture('users.csv'))

    translation = Rosetta::Translation.new(Rosetta::CSVSerializer, Rosetta::JSONDeserializer)
    expect(translation.call(input)).to eq(output)
  end

  it 'can guess which serializer/deserializer to use from format' do
    input = File.read(file_fixture('users.json'))
    output = File.read(file_fixture('users.csv'))

    translation = Rosetta::Translation.new(:csv, :json)
    expect(translation.call(input)).to eq(output)
  end
end
