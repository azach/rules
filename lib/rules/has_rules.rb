module Rules
  module HasRules
    def self.included(base)
      base.instance_eval do
        has_one :rule_set, class_name: 'Rules::RuleSet', as: :source, dependent: :destroy

        accepts_nested_attributes_for :rule_set, allow_destroy: true

        def has_rule_attributes(attributes = {})
          Rules::RuleSet.set_attributes_for(self, attributes)
        end
      end
    end

    def rule_set
      super || self.build_rule_set(source: self)
    end

    def rules_pass?(options = {})
      rule_set.nil? || rule_set.evaluate(options)
    end
  end
end
