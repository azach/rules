module Rules
  module HasRules
    def evaluate_rules(options = {})
      rule_set.evaluate(options)
    end

    def self.included(base)
      base.send(:attr_accessor, :rule_set)
    end
  end
end
