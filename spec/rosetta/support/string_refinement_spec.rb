require 'rosetta/support/string_refinement'

RSpec.describe Rosetta::Support, 'String refinement' do
  it 'adds an #underscore method to handle case transformation' do
    class UnderscoreTestDummy
      using Rosetta::Support

      def responds?
        "".respond_to? :underscore
      end

      def test_with(string)
        string.underscore
      end
    end

    expect(UnderscoreTestDummy.new.responds?).to be_truthy
    expect(UnderscoreTestDummy.new.test_with("HelloMyHoney")).to eq("hello_my_honey")
  end
end
