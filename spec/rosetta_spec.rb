require 'rosetta'

RSpec.describe Rosetta, '#translate' do
  it 'can translate from one format to another' do
    input = File.read(file_fixture('users.json'))
    output = File.read(file_fixture('users.csv'))
    expect(Rosetta.translate(input)).to eq(output)
  end
end
