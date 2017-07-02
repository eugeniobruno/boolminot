require 'coverage_helper'
require 'minitest/autorun'
require 'minitest/bender'
require 'pry-byebug'
require 'boolminot'

module Boolminot
  class Test < Minitest::Test
    def clause_factory
      Boolminot.clause_factory
    end

    def method_missing(name, *args, &block)
      if clause_factory.respond_to?(name)
        clause_factory.public_send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      clause_factory.respond_to?(method_name) || super
    end

    private

    def exists_example(suffix, opts = {})
      exists("field#{suffix}", opts)
    end

    def missing_example(suffix, opts = {})
      missing("field#{suffix}", opts)
    end

    def term_example
      term(:my_field, 'value')
    end

    def terms_example
      terms('my_field', %w(first_value second_value))
    end

    def range_with_bounds(bounds, opts = {})
      range(:field, bounds, opts)
    end

    def wildcard_example(opts = {})
      wildcard('user', 'ki*y', opts)
    end

    def script_example(opts = {})
      script(inner_script_example, opts)
    end

    def inner_script_example
      {
        "inline" => "doc['num1'].value > params.param1",
        "lang"   => "painless",
        "params" => { "param1" => 5 }
      }
    end

    def nested_example(opts = {})
      nested('values', exists_example(1), opts)
    end

    def query_string_example(opts = {})
      query_string(query_string_parameters_example, opts)
    end

    def query_string_parameters_example
      {
        default_field: "content",
        query: "this AND that OR thus"
      }
    end

    def conjunction_example(suffixes)
      conjunction(suffixes.map { |s| exists_example(s) })
    end

    def disjunction_example(suffixes)
      disjunction(suffixes.map { |s| exists_example(s) })
    end

    def at_least_example(amount, suffixes)
      at_least(amount, suffixes.map { |s| exists_example(s) })
    end

    def at_most_example(amount, suffixes)
      at_most(amount, suffixes.map { |s| exists_example(s) })
    end

    def exactly_example(amount, suffixes)
      exactly(amount, suffixes.map { |s| exists_example(s) })
    end
  end
end
