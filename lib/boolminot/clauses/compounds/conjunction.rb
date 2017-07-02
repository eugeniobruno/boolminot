module Boolminot
  module Clauses
    module Compounds
      class Conjunction < Logica::Predicates::Compounds::Conjunction
        extend  Clauses::Base::ClassMethods
        include Clauses::Base::InstanceMethods

        extend  Base::ClassMethods
        include Base::InstanceMethods

        def to_elasticsearch(options = {})
          bool = clauses.reduce({}) do |sections, clause|
            more_sections = clause.to_raw_bool(options.merge(added_to: sections)).fetch(:bool)
            sections.merge(more_sections) do |_, old_val, new_val|
              old_val + new_val
            end
          end

          { bool: bool }
        end
      end
    end
  end
end
