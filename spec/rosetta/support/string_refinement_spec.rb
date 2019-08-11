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
    expect(UnderscoreTestDummy.new.test_with("HelloMyBaby")).to eq("hello_my_baby")
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
    expect(CamelizeTestDummy.new.test_with("hello_my_honey")).to eq("HelloMyHoney")
  end

  it 'adds a #titleize method to handle case transformation' do
    class TitleizeTestDummy
      using Rosetta::Support

      def responds?
        "".respond_to? :titleize
      end

      def test_with(string)
        string.titleize
      end
    end

    expect(TitleizeTestDummy.new.responds?).to be_truthy
    expect(TitleizeTestDummy.new.test_with("hello_my_ragtime_gal")).to eq("Hello My Ragtime Gal")
  end

  it 'adds a #capitalize method to handle case transformation' do
    class CapitalizeTestDummy
      using Rosetta::Support

      def responds?
        "".respond_to? :capitalize
      end

      def test_with(string)
        string.capitalize
      end
    end

    expect(CapitalizeTestDummy.new.responds?).to be_truthy
    expect(CapitalizeTestDummy.new.test_with("hello my Summertime gal")).to(
            eq("Hello my summertime gal"))
  end

  it 'allows to check the case components of words' do
    class ComponentTestDummy
      using Rosetta::Support

      def responds?
        "".respond_to? :case_components
      end

      def test_with(string)
        string.case_components
      end
    end

    expect(ComponentTestDummy.new.responds?).to be_truthy
    expect(ComponentTestDummy.new.test_with("hello_my_baby")).to(
            eq(['hello', 'my', 'baby']))
    expect(ComponentTestDummy.new.test_with("HelloMyHoney")).to(
            eq(['Hello', 'My', 'Honey']))
    expect(ComponentTestDummy.new.test_with("Hello My Ragtime Gal")).to(
            eq(['Hello', 'My', 'Ragtime', 'Gal']))
    expect(ComponentTestDummy.new.test_with("Hello my summertime gal")).to(
            eq(['Hello', 'my', 'summertime', 'gal']))
  end
end
