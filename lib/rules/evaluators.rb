module Rules
  module Evaluators
    require 'rules/evaluators/evaluator'

    @@list ||= {}

    def self.list
      @@list
    end

    def self.define_evaluator(key, &block)
      raise 'Evaluator already exists' if @@list[key]
      evaluator = Evaluator.new(key)
      evaluator.instance_eval(&block) if block_given?
      @@list[key] = evaluator
    end
  end
end
