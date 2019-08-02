require 'rosetta/element'

RSpec.describe Rosetta::Element do
  it 'knows its internal properties' do
    element = Rosetta::Element.new('a' => 'b', 'c' => 'd')

    expect(element.properties).to eq(['a', 'c'])
  end

  it 'returns its properties as a flat structure even when its internals are nested' do
    element = Rosetta::Element.new('a' => { 'c' => 'd' })

    expect(element.properties).to eq(['a.c'])
  end

  it 'can get a value from its internal structure with a property key' do
    element = Rosetta::Element.new('a' => { 'c' => 'd' }, 'b' => 'e')

    expect(element['b']).to eq('e')
    expect(element['a.c']).to eq('d')
  end
end
