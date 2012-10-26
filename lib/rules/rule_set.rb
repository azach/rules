require 'rules/has_rules'
require 'rules/parameters/attribute'

module Rules
  class RuleSet < ActiveRecord::Base
    attr_accessible :rules, :evaluation_logic, :rules_attributes

    belongs_to :source, polymorphic: true

    has_many :rules, class_name: 'Rules::Rule'

    accepts_nested_attributes_for :rules, allow_destroy: true

    def self.set_context_for(klass, klass_contexts)
      @contexts ||= {}
      @contexts[klass] = attributize(klass_contexts)
    end

    def self.contexts
      @contexts || {}
    end

    def self.attributize(context_hashes)
      mapped_hash = {}
      context_hashes.each do |k, v|
        mapped_hash[k] = Rules::Parameters::Attribute.new(v.merge(attribute: k))
      end
      mapped_hash
    end

    def contexts
      return {} unless source
      self.class.contexts[source.class] || {}
    end

    # TODO: Arbitrary rule set logic (Treetop)
    def evaluate(context = {})
      rules.each do |rule|
        return false unless rule.evaluate(context)
      end
      true
    end
  end
end
