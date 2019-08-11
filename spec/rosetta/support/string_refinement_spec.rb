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

  it 'adds a #camelize method to handle case transformation' do
    class CamelizeTestDummy
      using Rosetta::Support

      def responds?
        "".respond_to? :camelize
      end

      def test_with(string)
        string.camelize
      end
    end

    expect(CamelizeTestDummy.new.responds?).to be_truthy
    expect(CamelizeTestDummy.new.test_with("hello_my_darling")).to eq("HelloMyDarling")
  end
end
