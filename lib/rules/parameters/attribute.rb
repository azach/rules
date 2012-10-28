require 'rules/parameters/parameter'

module Rules::Parameters
  class Attribute < Parameter
    attr_reader :key

    def initialize(options = {})
      @name = options[:name]
      @key  = options[:key].to_sym
    end

    def evaluate(attributes = {})
      if Rules.config.missing_attributes_are_nil?
        attributes[key]
      else
        attributes.fetch(key)
      end
    end
  end
end
