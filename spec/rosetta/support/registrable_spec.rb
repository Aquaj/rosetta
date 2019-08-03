require 'rosetta/support/registerable'

RSpec.describe Rosetta::Support::Registerable do
  before(:each) do
    class TestClass
      extend Rosetta::Support::Registerable
    end
  end

  it 'allows classes to have objects registered to them' do
    TestClass.registerable_as :test

    to_be_registered = Object.new
    TestClass.register :toto, to_be_registered

    expect(TestClass.registered[:toto]).to eq(to_be_registered)
  end

  it 'raises on registration key collision' do
    TestClass.registerable_as :test

    to_be_registered = Object.new
    TestClass.register :toto, to_be_registered
    expect { TestClass.register :toto, to_be_registered }.to(
      raise_error(Rosetta::RegistrationError))
  end

  it 'allows for custom error classes' do
    TestClass.registerable_as :test

    class TestClass::ExistingTestError < StandardError; end

    to_be_registered = Object.new
    TestClass.register :toto, to_be_registered
    expect { TestClass.register :toto, to_be_registered }.to(
      raise_error(TestClass::ExistingTestError))
  end

  it 'provides a [] shorthand access method' do
    TestClass.registerable_as :test

    to_be_registered = Object.new
    TestClass.register :toto, to_be_registered

    expect(TestClass[:toto]).to eq(to_be_registered)
  end

  it 'can register blocks' do
    TestClass.registerable_as :test

    to_be_registered = proc do
      "No op."
    end
    TestClass.register :toto, &to_be_registered

    expect(TestClass.registered[:toto]).to eq(to_be_registered)
  end

  it 'raises when you try to register both object and block' do
    TestClass.registerable_as :test

    registered_block = proc do
      "No op."
    end
    registered_obj = Object.new
    expect { TestClass.register :toto, registered_obj, &registered_block }.to(
      raise_error(ArgumentError))
  end

  after(:each) do
    Object.send(:remove_const, :TestClass)
  end
end
