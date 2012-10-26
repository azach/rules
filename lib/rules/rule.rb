require 'rules/evaluators'
require 'rules/parameters'

module Rules
  class Rule < ActiveRecord::Base
    attr_accessible :rule_set, :evaluator, :lhs_parameter, :rhs_parameter

    belongs_to :rule_set, class_name: 'Rules::RuleSet'

    validates :evaluator, presence: true, inclusion: {in: Evaluators.list.keys.map(&:to_s)}
    validates :lhs_parameter, presence: true, inclusion: {in: Parameters.constants.keys.map(&:to_s)}
    validates :rhs_parameter, presence: true, if: ->(rule) { rule.get_evaluator.try(:requires_rhs?) }
    validates :rhs_parameter, inclusion: {in: [], message: 'must be blank for this evaluation method'}, unless: ->(rule) { rule.get_evaluator.try(:requires_rhs?) }

    store :parameters, :accessors => [:lhs_parameter, :rhs_parameter]

    def evaluate(context = {})
      lhv = lhs_parameter_value(context)
      rhv = rhs_parameter_value
      get_evaluator.evaluate(lhv, rhv)
    end

    def get_evaluator
      @evaluator ||= evaluator ? Evaluators.list[evaluator.to_sym] : nil
    end

    def lhs_parameter_value(context = {})
      @lhs_parameter_value ||= lhs_parameter_object.evaluate(context)
    end

    def rhs_parameter_value
      @rhs_parameter_value ||= cast(rhs_parameter)
    end

    def lhs_parameter_object
      lhs_parameter ? Parameters.constants[lhs_parameter.to_sym] : nil
    end

    private

    def cast(value)
      lhs_parameter_object.cast(value) rescue nil
    end
  end
end