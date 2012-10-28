require 'rules/evaluators'
require 'rules/parameters'
require 'rules/extensions/active_model/absence_validator'

module Rules
  class Rule < ActiveRecord::Base
    attr_accessible :rule_set, :evaluator, :lhs_parameter_key, :rhs_parameter

    belongs_to :rule_set, class_name: 'Rules::RuleSet'

    validates :evaluator, presence: true, inclusion: {in: Evaluators.list.keys.map(&:to_s)}
    validates :lhs_parameter_key, presence: true, inclusion: {in: ->(rule) { rule.valid_parameter_keys }}
    validates :rhs_parameter, presence: true, if: ->(rule) { rule.get_evaluator.try(:requires_rhs?) }
    validates :rhs_parameter, absence: true, unless: ->(rule) { rule.get_evaluator.try(:requires_rhs?) }

    store :parameters, :accessors => [:lhs_parameter_key, :rhs_parameter]

    def evaluate(attributes = {})
      lhv = lhs_parameter_value(attributes)
      rhv = rhs_parameter_value if get_evaluator.requires_rhs?
      get_evaluator.evaluate(lhv, rhv)
    end

    def get_evaluator
      @get_evaluator ||= evaluator ? Evaluators.list[evaluator.to_sym] : nil
    end

    def lhs_parameter_value(attributes = {})
      lhs_parameter.try(:evaluate, attributes)
    end

    def rhs_parameter_value
      lhs_parameter ? lhs_parameter.cast(rhs_parameter) : rhs_parameter
    end

    def lhs_parameter
      @lhs_parameter ||= if lhs_parameter_key
        Parameters.constants[lhs_parameter_key.to_sym] \
          || valid_attributes[lhs_parameter_key.to_sym]
      else
        nil
      end
    end

    def valid_parameter_keys
      Parameters.constants.keys.map(&:to_s) + valid_attributes.keys.map(&:to_s)
    end

    def valid_attributes
      rule_set ? rule_set.attributes : {}
    end
  end
end
