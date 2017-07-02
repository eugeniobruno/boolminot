module Boolminot
  module Helpers
    class RangeBoundsValidator
      attr_reader :bounds

      def initialize(bounds)
        @bounds = bounds
      end

      def valid?
        good_keys    = bounds.keys.all? { |key| valid_keys.include?(key) }
        any_bound    = !(lower_bounds + upper_bounds).empty?
        well_defined = [lower_bounds, upper_bounds].all? { |bounds| bounds.size <= 1 }

        good_keys && any_bound && well_defined
      end

      private

      def valid_keys
        %i[gt gte lt lte]
      end

      def lower_bounds
        [bounds[:gt], bounds[:gte]].compact
      end

      def upper_bounds
        [bounds[:lt], bounds[:lte]].compact
      end
    end
  end
end
