require 'rules/has_rules'
require 'rules/parameters/attribute'

module Rules
  class RuleSet < ActiveRecord::Base
    attr_accessible :rules, :evaluation_logic, :rules_attributes

    belongs_to :source, polymorphic: true

    has_many :rules, class_name: 'Rules::Rule'

    accepts_nested_attributes_for :rules, allow_destroy: true

    validates_inclusion_of :evaluation_logic, in: %w(all any), allow_nil: true, allow_blank: true

    @@attributes = Hash.new({})

    def self.set_attributes_for(klass, klass_attributes)
      @@attributes[klass] = @@attributes[klass].merge(attributize(klass_attributes))
    end

    def self.attributes
      @@attributes
    end

    def self.attributize(attributes_hash)
      mapped_hash = {}
      attributes_hash.each do |k, v|
        mapped_hash[k] = Rules::Parameters::Attribute.new(v.merge(key: k))
      end
      mapped_hash
    end

    def attributes
      source_klass = source ? source.class : source_type.try(:constantize)
      return {} unless source_klass
      self.class.attributes[source_klass]
    end

    # TODO: Arbitrary rule set logic (Treetop)
    def evaluate(attributes = {})
      return true unless rules.any?
      if evaluation_logic == 'any'
        !!rules.detect { |rule| rule.evaluate(attributes) }
      else
        rules.each do |rule|
          return false unless rule.evaluate(attributes)
        end
        true
      end
    end
  end
end
