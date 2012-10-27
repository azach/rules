require 'rules/parameters/parameter'

module Rules::Parameters
  class Attribute < Parameter
    attr_reader :key

    def initialize(options = {})
      @name = options[:name]
      @key  = options[:key].to_sym
    end

    def evaluate(attributes = {})
      attributes.fetch(key)
    end
  end
end
