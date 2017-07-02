module Boolminot
  class ClauseFactory < Logica::PredicateFactory
    def generic(type, body, opts = {})
      Clauses::Generic.new(type.to_sym, body, opts)
    end

    def exists(field, opts = {})
      generic(:exists, { field: field.to_sym }, opts)
    end

    def missing(field, opts = {})
      exists(field, opts).negated
    end

    def term(field, value, opts = {})
      Clauses::Terms.new(field, [value], opts)
    end

    def terms(field, values, opts = {})
      Clauses::Terms.new(field, values, opts)
    end

    def range(field, bounds, opts = {})
      Clauses::Range.new(field, bounds, opts)
    end

    def geo_bounding_box(field, bounding_box, opts = {})
      generic(:geo_bounding_box, { field => bounding_box }, opts)
    end

    def nested(path, clause, opts = {})
      Clauses::Nested.new(path, clause, opts)
    end

    def script(script, opts = {})
      generic(:script, { script: script }, opts)
    end

    def query_string(parameters, opts = {})
      generic(:query_string, parameters, opts)
    end

    def wildcard(field, expression, opts = {})
      generic(:wildcard, { field => expression }, opts)
    end

    def match_all
      tautology
    end

    def match_none
      contradiction
    end

    private

    def negation_class
      Clauses::Negation
    end

    def conjunction_class
      Clauses::Compounds::Conjunction
    end

    def disjunction_class
      Clauses::Compounds::Disjunction
    end

    def at_least_class
      Clauses::Compounds::AtLeast
    end

    def tautology_class
      Clauses::MatchAll
    end

    def contradiction_class
      Clauses::MatchNone
    end
  end
end
