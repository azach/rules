require 'rules/evaluators'
require 'rules/parameters'

module Rules
  class Rule < ActiveRecord::Base

    attr_accessible :rule_set, :evaluator, :lhs_parameter, :rhs_parameter

    store :parameters, :accessors => [:lhs_parameter, :rhs_parameter]

    belongs_to :rule_set, class_name: 'Rules::RuleSet'

    validates :evaluator, presence: true
    validates :lhs_parameter, presence: true
    validates :rhs_parameter, presence: true, if: ->(rule) { rule.evaluator.try(:requires_rhs?) }

    def evaluate(context = {})
      lhv = value(lhs_parameter, context)
      rhv = value(rhs_parameter, context)
      evaluator.evaluate(lhv, rhv)
    end

    def evaluator=(evaluator)
      super(Evaluators.list[evaluator.to_sym])
    end

    private

    def value(parameter, *args)
      parameter.respond_to?(:evaluate) ? parameter.evaluate(context) : parameter
    end
  end
end