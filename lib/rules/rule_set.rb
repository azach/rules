require 'rules/rule'

module Rules
  class RuleSet
    attr_reader :rules

    def initialize(rules)
      @rules = rules || []
    end

    # TODO: Arbitrary rule set logic
    def evaluate(context = {})
      rules.each do |rule|
        raw_value = rule.context ? context[rule.context.to_sym] : nil
        return false unless rule.evaluate(raw_value)
      end
      true
    end
  end
end
