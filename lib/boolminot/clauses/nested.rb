module Boolminot
  module Clauses
    class Nested < Base
      attr_reader :path, :clause, :opts

      def initialize(path, clause, opts)
        @path   = path
        @clause = clause
        @opts   = opts
      end

      def to_elasticsearch(options = {})
        default_options = {
          context: :filter
        }
        options = default_options.merge(options)

        context = options.fetch(:context)
        inner   = clause.to_elasticsearch(options)

        { type => { path: path }.merge(context => inner).merge(opts) }
      end
    end
  end
end
