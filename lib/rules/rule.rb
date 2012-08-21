require 'rules/evaluators'
require 'rules/parameters'

module Rules
  class Rule
    extend ActiveModel::Naming

    attr_reader :evaluator, :lhs_parameter, :rhs_parameter

    def initialize(evaluator, lhs_parameter, rhs_parameter = nil)
      raise 'Invalid evaluator' unless evaluator = Evaluators.list[evaluator]
      raise ArgumentError.new("#{evaluator} requires a right hand side parameter") if evaluator.requires_rhs? && rhs_parameter.nil?

      @evaluator = evaluator
      @lhs_parameter = lhs_parameter
      @rhs_parameter = rhs_parameter
    end

    def evaluate(options = {})
      lhv = value(lhs_parameter, options[:lhs_raw_value])
      rhv = value(rhs_parameter, options[:rhs_raw_value])
      evaluator.evaluate(lhv, rhv)
    end

    private

    def value(parameter, *args)
      parameter.respond_to?(:evaluate) ? parameter.evaluate(*args) : parameter
    end
  end
end