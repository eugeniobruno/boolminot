module Boolminot
  module Clauses
    class Generic < Base
      attr_reader :type, :body, :opts

      def initialize(type, body, opts = {})
        @type = type.to_sym
        @body = body
        @opts = opts
      end
    end
  end
end
