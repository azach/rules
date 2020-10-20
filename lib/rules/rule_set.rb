require 'rules/has_rules'
require 'rules/parameters/attribute'

module Rules
  class RuleSet < ActiveRecord::Base
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

    def source_class
      source ? source.class : source_type.try(:constantize)
    end

    def attributes
      return {} unless source_class
      self.class.attributes[source_class]
    end

    def add_association_value_to_hash!(hash, parameter)
      key = parameter.key
      reflection_name = parameter.association.to_s
      association = source_class.reflections[reflection_name]
      return unless association

      if association.collection? # has_many or similar
        associated_items = source.send(reflection_name)
        associated_items.each do |item|
          hash[key] ||= []
          hash[key] << item.send(
            parameter.associated_attribute_name
          )
        end
      else
        associated_item = source.send(reflection_name)
        if associated_item
          hash[key] ||= associated_item.send(parameter.associated_attribute_name)
        end
      end
    end

    def add_local_value_to_hash!(hash, parameter)
      hash[parameter.key] = source.send(parameter.key)
    end

    def collected_attributes
      mapped_hash = {}
      attributes.each do |key, parameter|
        begin
          if parameter.association
            add_association_value_to_hash!(mapped_hash, parameter)
          else
            add_local_value_to_hash!(mapped_hash, parameter)
          end
        rescue
          message = "rules gem: Parameter #{parameter.key} appears to be misconfigured."
          Rails ? Rails.logger.warn(message) : puts(message)
        end
      end
      mapped_hash
    end

    # TODO: Arbitrary rule set logic (Treetop)
    def evaluate(attributes = {})
      return true unless rules.any?
      attributes_to_evaluate = collected_attributes.merge(attributes)
      if evaluation_logic == 'any'
        !!rules.detect { |rule| rule.evaluate(attributes_to_evaluate) }
      else
        rules.each do |rule|
          return false unless rule.evaluate(attributes_to_evaluate)
        end
        true
      end
    end
  end
end
