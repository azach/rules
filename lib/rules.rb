require 'rules/evaluators'
require 'rules/evaluators/definitions'
require 'rules/parameters'
require 'rules/rule'
require 'rules/rule_set'

module Rules
  def self.evaluators
    @evaluators ||= Evaluators.list
  end
end
