module Rules
  module HasRules
    def self.included(base)
      base.instance_eval do
        has_one :rule_set, class_name: 'Rules::RuleSet', as: :source, dependent: :destroy

        attr_accessible :rule_set_attributes
        accepts_nested_attributes_for :rule_set, allow_destroy: true

        def define_rule_contexts(contexts = {})
          Rules::RuleSet.set_context_for(self, contexts)
        end
      end
    end

    def rule_set
      super || Rules::RuleSet.new
    end

    def rules_pass?(options = {})
      rule_set.nil? || rule_set.evaluate(options)
    end
  end
end
