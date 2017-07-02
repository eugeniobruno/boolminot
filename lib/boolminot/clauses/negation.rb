module Boolminot
  module Clauses
    class Negation < Logica::Predicates::Negation
      extend  Base::ClassMethods
      include Base::InstanceMethods

      def to_elasticsearch(options = {})
        clause.to_elasticsearch_negated(options)
      end

      def to_raw_bool(options = {})
        to_elasticsearch(options)
      end

      def clause
        predicate
      end
    end
  end
end
