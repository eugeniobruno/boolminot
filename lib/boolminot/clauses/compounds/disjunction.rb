module Boolminot
  module Clauses
    module Compounds
      class Disjunction < Logica::Predicates::Compounds::Disjunction
        extend  Clauses::Base::ClassMethods
        include Clauses::Base::InstanceMethods

        extend  Base::ClassMethods
        include Base::InstanceMethods

        def to_elasticsearch_negated(options = {})
          { bool: { must_not: clauses.map { |c| c.to_elasticsearch(options) } } }
        end

        def or_with_terms(terms_clause, options = {})
          default_options = {
            argument_first: true
          }
          options = default_options.merge(options)

          return super(terms_clause) unless terms_clause.opts.empty?

          terms_clauses_with_same_field, others = clauses.partition { |q| q.terms_with_field?(terms_clause.field) }

          return super(terms_clause) if terms_clauses_with_same_field.empty?

          with_same_field = terms_clauses_with_same_field.first # no disjunction would have two terms with the same field
          same_field      = with_same_field.field
          values          = with_same_field.values
          more_values     = terms_clause.values

          all_values = options[:argument_first] ? (more_values + values) : (values + more_values)
          with_more_values = clause_factory.terms(same_field, all_values)

          updated_clauses = options[:argument_first] ? ([with_more_values] + others) : (others + [with_more_values])
          clause_factory.disjunction(updated_clauses)
        end

        private

        def to_elasticsearch_in_query_context
          {
            bool: {
              should: clauses.map { |c| c.to_elasticsearch(context: :query) },
              minimum_should_match: 1
            }
          }
        end

        def to_elasticsearch_in_filter_context
          { bool: { should: clauses.map { |c| c.to_elasticsearch(context: :filter) } } }
        end
      end
    end
  end
end
