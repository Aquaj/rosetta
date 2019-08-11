# Rosetta
[![Build Status](https://travis-ci.com/Aquaj/rosetta.svg?branch=master)](https://travis-ci.com/Aquaj/rosetta)  [![Gem Version](https://badge.fury.io/rb/rosetta-stone.svg)](https://badge.fury.io/rb/rosetta-stone)

A lightweight format-to-format translator.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rosetta-stone'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rosetta-stone

## Usage

### `Rosetta.translate`

The easiest way to use the library is to `require 'rosetta'` first, and then
where needed:
```ruby
Rosetta.translate(my_input_text, from: <input_format>, to: <output_format>)
```
Example:
```ruby
input_text = JSON.parse(File.open('example.json'))
Rosetta.translate(input_text, from: :json, to: :csv)
```

### `Rosetta::Translation`

For more flexibility you can also use `Rosetta::Translation` to create callable
objects that will perform the translation. Example:

```ruby
translation = Rosetta::Translation.new(:json, :csv)
input_text = JSON.parse(File.open('example.json'))
translation.call(input_text)

# or

json_files = [ # ... ]
translation = Rosetta::Translation.new(:json, :csv)
json_files.map(&translation)

```

The `Rosetta.translate` method and the `Rosetta::Translation.new` method both
can take callable objects instead of formats. The first one will be ued to
deserialize/parse the input, the second one to serialize/generate the output.

```ruby
deserializer = -> (input) { input.reverse }
serializer = -> (input) { input.upcase }
Rosetta::Translation.new(deserializer, serializer).call("olleh") # => HELLO
```

When given `Symbol`s instead, they will try to lookup the registered serializers
and deserializers to find a match to use with the input.
By default, the only ones supplied with the gem are a JSON deserializer and a
CSV serializer. (`Rosetta::Deserializers::JSON` and `Rosetta::Serializers::CSV`).
See *Registering a Serializer / Deserializer* for more info on how to add your own.

You can also register `Translator`s, which are pipes connecting to specific
formats rather than using a Deserializer + Serializer combo.
See *Registering a Translator* for more info on how to use them.

### Registering a Serializer / Deserializer

You can register a new serializer or deserializer by calling the `register`
methods of respectively `Rosetta::Serializers` or `Rosetta::Deserializers`.
The method takes the Symbol that's going to be used as shorthand for it as first
parameter and either a callable object or a block for the serializer/deserializer.

Example:
```ruby
deserializer = -> (input) { input.reverse }
serializer = -> (input) { input.upcase }

Rosetta::Deserializers.register(:mirror, deserializer)
Rosetta::Serializers.register(:BIG, serializer)

Rosetta.translate(from: :mirror, to: :big, "em ti si") # => "IS IT ME"

# Alternative

Rosetta::Deserializers.register(:BIG)    { |input| input.upcase  }
Rosetta::Deserializers.register(:mirror) { |input| input.reverse }
```

Whatever the Deserializer returns will be fed to the Serializer when
translating, but to improve reusability and a "grab bag" approach to them, it's
recommended to have Deserializers return a collection of `Rosetta::Element`s and
to have Serializers assume they are receiving one as parameter.

`Rosetta::Element` are wrapper objects around what's been given to their
constructor, traditionally a Hash or nested Hashes.
They can introspect and return a flat list of all the keys in their content, and
they respond to `[]` to access the values associated with those keys.

```ruby
simple = Rosetta::Element.new({ place: 'My home', time: 'Later today', activity: 'Chilling' })
                         .properties # =>  [:place, :time, :activity]

simple['place'] # => "My home"

nested = Rosetta::Element.new({ place: { country: 'USA', state: 'West Virginia', town: 'Kepler' },
                                time: { day: 'Thursday' } })
                          .properties # =>  ['place.country', 'place.state', 'place.town', 'time.day']

nested['place.town'] # => "Kepler"

```

### Registering a Translator

For many reasons (performance, development time, cohabitation with other libraries, ...)
you might want to avoid developing and using a Deserializer and a Serializer and
would rather prefer going straight from a specific format to another specific
one.

The way to do so is to register a `Translator` by calling
`Rosetta::Translation.register`.
The method takes the source and destination formats as the first two parameters and either
a callable object or a block as the translator.

Example:
```ruby
# Either
  translator = lambda do |input|
    input.upcase
  end
  Rosetta::Translation.register(:down, :up, translator)
# or
  Rosetta::Translation.register(:down, :up) { |input| input.upcase }
# are equivalent.

Rosetta::Translation.new(:down, :up).call("you're looking for")
  # => "YOU'RE LOOKING FOR"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Aquaj/rosetta. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rosetta project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Aquaj/rosetta/blob/master/CODE_OF_CONDUCT.md).
