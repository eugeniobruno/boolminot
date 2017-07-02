module Boolminot
  module Clauses
    class MatchAll < Logica::Predicates::Tautology
      extend  Base::ClassMethods
      include Base::InstanceMethods

      def initialize(opts = {})
        @opts = opts
      end

      def body
        opts
      end
    end
  end
end
