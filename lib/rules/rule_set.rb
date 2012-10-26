require 'rules/has_rules'

module Rules
  class RuleSet < ActiveRecord::Base
    attr_accessible :rules, :evaluation_logic, :rules_attributes

    belongs_to :source, polymorphic: true

    has_many :rules, class_name: 'Rules::Rule'

    accepts_nested_attributes_for :rules, allow_destroy: true

    # TODO: Arbitrary rule set logic (Treetop)
    def evaluate(context = {})
      rules.each do |rule|
        return false unless rule.evaluate(context)
      end
      true
    end
  end
end
