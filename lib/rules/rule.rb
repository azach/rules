require 'rules/evaluators'
require 'rules/parameters'

module Rules
  class Rule < ActiveRecord::Base
    attr_accessible :rule_set, :evaluator_key, :lhs_parameter_key, :rhs_parameter_key, :rhs_parameter_raw

    belongs_to :rule_set, class_name: 'Rules::RuleSet'

    validates :evaluator_key, presence: true, inclusion: {in: Evaluators.list.keys.map(&:to_s)}
    validates :lhs_parameter_key, parameter_key: true
    validates :rhs_parameter_key, parameter_key: true, if: :rhs_parameter_key
    validates :rhs_parameter_key, presence: true, if: :requires_rhs?, unless: :rhs_parameter_raw
    validates :rhs_parameter_key, absence: true, unless: :requires_rhs?
    validates :rhs_parameter_raw, absence: true, unless: :requires_rhs?
    validates :rhs_parameter_raw, absence: true, if: :rhs_parameter_key

    store :expression, :accessors => [:evaluator_key, :lhs_parameter_key, :rhs_parameter_key, :rhs_parameter_raw]

    def evaluate(attributes = {})
      lhv = lhs_parameter_value(attributes)
      rhv = rhs_parameter_value(attributes) if evaluator.requires_rhs?
      evaluator.evaluate(lhv, rhv)
    end

    def evaluator
      @evaluator ||= evaluator_key ? Evaluators.list[evaluator_key.to_sym] : nil
    end

    def lhs_parameter_key
      expression[:lhs_parameter_key].blank? ? nil : expression[:lhs_parameter_key]
    end

    def rhs_parameter_key
      expression[:rhs_parameter_key].blank? ? nil : expression[:rhs_parameter_key]
    end

    def lhs_parameter_value(attributes = {})
      lhs_parameter.try(:evaluate, attributes)
    end

    def rhs_parameter_value(attributes = {})
      rhv = if rhs_parameter.respond_to?(:evaluate)
        rhs_parameter.try(:evaluate, attributes)
      else
        lhs_parameter ? lhs_parameter.cast(rhs_parameter) : rhs_parameter
      end
    end

    def rhs_parameter
      if rhs_parameter_key
        parameter_from_key(rhs_parameter_key.to_sym)
      else
        rhs_parameter_raw
      end
    end

    def lhs_parameter
      @lhs_parameter ||= parameter_from_key(lhs_parameter_key.try(:to_sym))
    end

    def valid_parameter_keys
      Parameters.constants.keys.map(&:to_s) + valid_attributes.keys.map(&:to_s)
    end

    def valid_attributes
      rule_set ? rule_set.attributes : {}
    end

    def requires_rhs?
      evaluator ? evaluator.requires_rhs? : false
    end

    private

    def parameter_from_key(key)
      if key
        Parameters.constants[key] || valid_attributes[key]
      else
        nil
      end
    end
  end
end
