require 'rules/engine'
require 'rules/evaluators'
require 'rules/evaluators/definitions'
require 'rules/has_rules'
require 'rules/parameters'
require 'rules/parameters/constant_definitions'
require 'rules/rule'
require 'rules/rule_set'

module Rules
  def self.evaluators
    @evaluators ||= Evaluators.list
  end

  def self.constants
  	@constants ||= Parameters.constants
  end
end
