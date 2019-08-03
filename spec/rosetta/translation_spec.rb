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

  it 'can take callable objects as translation objects' do
    lambda_deserializer = lambda do |input|
      input.split("\n").map do |line|
        attributes = line.split(";").map { |i| i.split(',') }.to_h
        Rosetta::Element.new(attributes)
      end
    end

    proc_serializer = proc do |elements|
      elements.map do |element|
        element.properties.map do |prop|
          element[prop]
        end.join('-')
      end.join("\n")
    end

    translation = Rosetta::Translation.new(proc_serializer, lambda_deserializer)
    expect(translation.call(<<~INPUT.chomp)).to eq(<<~OUTPUT.chomp)
    a,b;c,d;
    1,2;3,4;
    INPUT
    b-d
    2-4
    OUTPUT
  end

  it 'can use a pre-registered callable object to do a specific format-to-format translation' do
     translator = lambda do |input|
      input.upcase
    end
     Rosetta::Translation.register(:down, :up, translator)

    expect(Rosetta::Translation.new(:down, :up).call("hello")).to eq("HELLO")
  end


  it 'can use a pre-registered block to do a specific format-to-format translation' do
    Rosetta::Translation.register(:down, :up) do |input|
      input.upcase
    end

    expect(Rosetta::Translation.new(:down, :up).call("hello")).to eq("HELLO")
  end
end
