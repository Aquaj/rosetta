require 'rosetta'

RSpec.describe Rosetta, '#convert' do
  it 'takes a JSON array of structured objects and outputs it as a CSV table' do
    input = File.read(file_fixture('users.json'))
    output = File.read(file_fixture('users.csv'))
    expect(Rosetta.convert(input)).to eq(output)
  end

  it 'raises if passed invalid JSON as an input' do
    input = File.read(file_fixture('users.json'))
    input = input[0..-10] # Incomplete file
    expect { Rosetta.convert(input) }.to raise_error(ArgumentError)
  end
end
