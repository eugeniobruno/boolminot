module Boolminot
  module Clauses
    class Base < Logica::Predicates::Base
      module ClassMethods
        def predicate_factory
          Boolminot.clause_factory
        end
      end

      module InstanceMethods
        def satisfied_by?(document)
          raise NoMethodError, 'Sorry; Boolminot clauses do not act as percolators'
        end

        def to_elasticsearch(options = {})
          default_options = {
            context: :filter
          }
          options = default_options.merge(options)

          send "to_elasticsearch_in_#{options[:context]}_context"
        end

        def to_elasticsearch_negated(options = {})
          { bool: { must_not: [to_elasticsearch(options)] } }
        end

        def to_raw_bool(options = {})
          { bool: { must: [to_elasticsearch(options)] } }
        end

        protected

        def terms_with_field?(field)
          false
        end

        private

        def type
          OpenHouse.simple_inflector.underscored_demodulized(self.class.name).to_sym
        end

        def to_elasticsearch_in_query_context
          to_elasticsearch_in_filter_context
        end

        def to_elasticsearch_in_filter_context
          { type => body.merge(opts) }
        end

        def opts
          {}
        end

        def clause_factory
          predicate_factory
        end
      end

      extend ClassMethods
      include InstanceMethods
    end
  end
end
