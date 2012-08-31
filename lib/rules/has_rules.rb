module Rules
  module HasRules
    def self.included(base)
      base.instance_eval do
        has_one :rule_set, class_name: 'Rules::RuleSet', as: :source, dependent: :destroy

        accepts_nested_attributes_for :rule_set, allow_destroy: true
      end
    end

    def rule_set
      read_attribute(:rule_set) || Rules::RuleSet.new
    end

    def evaluate_rules(options = {})
      rule_set.evaluate(options)
    end
  end
end
