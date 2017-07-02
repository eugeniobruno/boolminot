module Boolminot
  module Clauses
    class Range < Base
      attr_reader :field, :bounds, :opts

      def initialize(field, bounds, opts = {})
        @field  = field.to_sym
        @bounds = normalized(bounds)
        @opts   = opts
        validate_consistency
      end

      def lower_bound
        bounds[:gt] || bounds[:gte]
      end

      def upper_bound
        bounds[:lt] || bounds[:lte]
      end

      def and(other)
        other.and_with_range(self)
      end

      def and_with_range(range_clause)
        return super unless opts.empty? && range_clause.opts.empty?
        return super unless field == range_clause.field

        new_bounds = bounds.merge(range_clause.bounds) { return super }

        valid_bounds = Helpers::RangeBoundsValidator.new(new_bounds).valid?
        return super unless valid_bounds

        clause_factory.range(field, new_bounds)
      end

      private

      def to_elasticsearch_in_filter_context
        { type => { field => body } }
      end

      def body
        bounds.merge(opts)
      end

      def normalized(hash)
        hash.each_with_object(hash.class.new) do |(k, v), h|
          h[k.to_sym] = v
        end
      end

      def validate_consistency
        valid = Helpers::RangeBoundsValidator.new(bounds).valid?
        raise ArgumentError, "invalid range bounds: #{bounds}" unless valid
      end
    end
  end
end
