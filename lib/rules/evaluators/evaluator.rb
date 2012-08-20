module Rules
  module Evaluators
    class Evaluator
      attr_accessor :evaluation_method, :requires_rhs, :name

      def initialize(key)
        @name = key.to_s
        @requires_rhs = true
      end

      def evaluate(lhs, rhs = nil)
        raise 'Unknown evaluation method' unless evaluation_method
        requires_rhs? ? evaluation_method.call(lhs, rhs) : evaluation_method.call(lhs)
      end

      def requires_rhs?
        @requires_rhs
      end

      def to_s
        @name
      end
    end
  end
end
