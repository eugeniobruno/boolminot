module Boolminot
  module Clauses
    module Compounds
      class AtLeast < Logica::Predicates::Compounds::AtLeast
        extend  Clauses::Base::ClassMethods
        include Clauses::Base::InstanceMethods

        extend  Base::ClassMethods
        include Base::InstanceMethods

        private

        def to_elasticsearch_in_query_context
          {
            bool: {
              should: clauses.map { |c| c.to_elasticsearch(context: :query) },
              minimum_should_match: amount
            }
          }
        end

        def to_elasticsearch_in_filter_context
          to_disjunction.to_elasticsearch(context: :filter)
        end
      end
    end
  end
end
