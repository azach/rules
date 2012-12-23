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
    validates :rhs_parameter_key, absence: true, if: :rhs_parameter_raw

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
      key_from_store :lhs_parameter_key
    end

    def rhs_parameter_key
      key_from_store :rhs_parameter_key
    end

    def evaluator_key
      key_from_store :evaluator_key
    end

    def lhs_parameter_value(attributes = {})
      lhs_parameter.try(:evaluate, attributes)
    end

    def rhs_parameter_value(attributes = {})
      if rhs_parameter.respond_to?(:evaluate)
        rhs_parameter.try(:evaluate, attributes)
      else
        rhv = Parameters::Parameter.cast(rhs_parameter_raw, lhs_parameter.try(:type))
        Parameters::Parameter.cast(rhv, evaluator.try(:type_for_rhs))
      end
    end

    def rhs_parameter
      rhs_parameter_key ? parameter_from_key(rhs_parameter_key) : rhs_parameter_raw
    end

    def lhs_parameter
      @lhs_parameter ||= lhs_parameter_key ? parameter_from_key(lhs_parameter_key) : nil
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

    def rule_set
      super || ObjectSpace.each_object(RuleSet).detect { |rs| rs.rules.include?(self) }
    end

    private

    def key_from_store(key)
      expression[key].blank? ? nil : expression[key]
    end

    def parameter_from_key(key)
      Parameters.constants[key.to_sym] || valid_attributes[key.to_sym]
    end
  end
end
