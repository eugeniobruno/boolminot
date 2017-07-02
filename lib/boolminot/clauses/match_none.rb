module Boolminot
  module Clauses
    class MatchNone < Logica::Predicates::Contradiction
      extend  Base::ClassMethods
      include Base::InstanceMethods

      def initialize(opts = {})
        @opts = opts
      end

      # only for compatibility with Elasticsearch 1.x and 2.x
      # otherwise, defining body as opts would suffice
      def to_elasticsearch(options = {})
        to_raw_bool(options)
      end

      def to_raw_bool(options = {})
        { bool: { must_not: [negated.to_elasticsearch(options)] } }
      end
      # ---
    end
  end
end
