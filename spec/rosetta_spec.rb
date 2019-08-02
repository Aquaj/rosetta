require 'rosetta'

RSpec.describe Rosetta, '#translate' do
  it 'takes a JSON array of structured objects and outputs it as a CSV table' do
    input = File.read(file_fixture('users.json'))
    output = File.read(file_fixture('users.csv'))
    expect(Rosetta.translate(input)).to eq(output)
  end
end
