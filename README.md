# Boolminot

[![Gem Version](https://badge.fury.io/rb/boolminot.svg)](https://badge.fury.io/rb/boolminot)
[![Build Status](https://travis-ci.org/eugeniobruno/boolminot.svg?branch=master)](https://travis-ci.org/eugeniobruno/boolminot)
[![Coverage Status](https://coveralls.io/repos/github/eugeniobruno/boolminot/badge.svg?branch=master)](https://coveralls.io/github/eugeniobruno/boolminot?branch=master)
[![Code Climate](https://codeclimate.com/github/eugeniobruno/boolminot.svg)](https://codeclimate.com/github/eugeniobruno/boolminot)
[![Dependency Status](https://gemnasium.com/eugeniobruno/boolminot.svg)](https://gemnasium.com/eugeniobruno/boolminot)

Boolminot provides composable models of [Elasticsearch](https://www.elastic.co/products/elasticsearch) clauses, built on top of the [Logica](https://github.com/eugeniobruno/logica) predicate framework.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'boolminot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boolminot

## Usage

Here is a simple example:

```ruby
has_any_color   = Boolminot.clause_factory.exists(:colors)
has_color_white = Boolminot.clause_factory.term(:colors, 'white')
has_color_red   = Boolminot.clause_factory.term(:colors, 'red')
has_color_green = Boolminot.clause_factory.term(:colors, 'green')
is_machine_washable = Boolminot.clause_factory.term(:machine, true)

has_any_color.to_elasticsearch
{ exists: { field: :colors } }

has_color_red.to_elasticsearch
{ term: { colors: 'red'} }

has_color_white.and(has_color_red).to_elasticsearch
{ bool: { must: [ { term: { colors: 'white' } }, { term: { colors: 'red' } } ] } }

has_color_white.or(has_color_red).to_elasticsearch
{ terms: { colors: ['white', 'red'] } }

has_color_white.or(is_machine_washable).to_elasticsearch
{ bool: { should: [ { term: { colors: 'white' } }, { term: { machine: true } } ] } }

has_color_green.negated.to_elasticsearch
{ bool: { must_not: [ { term: { colors: 'green' } } ] } }
```

More examples with other clause types can be found in the test files.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eugeniobruno/boolminot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

