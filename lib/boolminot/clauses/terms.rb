module Boolminot
  module Clauses
    class Terms < Base
      attr_reader :field, :values, :opts

      def initialize(field, values, opts = {})
        @field  = field.to_sym
        @values = values.uniq
        @opts   = opts
      end

      def or(other)
        other.or_with_terms(self)
      end

      def or_with_terms(terms_clause)
        return super unless opts.empty? && terms_clause.opts.empty?
        return super unless field == terms_clause.field

        clause_factory.terms(field, terms_clause.values + values)
      end

      def or_with_disjunction(disjunction)
        disjunction.or_with_terms(self, argument_first: false)
      end

      def specialization_of?(other)
        other.generalization_of_terms?(self)
      end

      def generalization_of_terms?(terms_clause)
        return super unless opts.empty? && terms_clause.opts.empty?
        field == terms_clause.field && terms_clause.values.all? { |v| values.include?(v) }
      end

      def terms_with_field?(some_field)
        some_field == field
      end

      private

      def type
        term? ? :term : super
      end

      def body
        { field => value_or_values }
      end

      def value_or_values
        term? ? values.first : values
      end

      def term?
        values.size == 1
      end
    end
  end
end
