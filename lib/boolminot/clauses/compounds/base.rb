module Boolminot
  module Clauses
    module Compounds
      class Base < Clauses::Base
        module ClassMethods
        end

        module InstanceMethods
          def clauses
            predicates
          end

          def to_raw_bool(options = {})
            if options.fetch(:added_to, {}).fetch(:should, []).empty?
              to_elasticsearch(options)
            else
              super
            end
          end
        end

        extend  ClassMethods
        include InstanceMethods
      end
    end
  end
end
