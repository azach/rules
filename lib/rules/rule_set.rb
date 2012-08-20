require 'rules/rule'

module Rules
  class RuleSet
    attr_reader :rules

    def initialize(rules)
      @rules = rules || []
    end

    # TODO: Arbitrary rule set logic
    def evaluate(options = {})
      rules.each do |rule|
        return false unless rule.evaluate(options)
      end
      true
    end
  end
end