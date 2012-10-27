require 'rules/parameters/parameter'

module Rules::Parameters
  class Attribute < Parameter
    attr_reader :attribute

    def initialize(options = {})
      @name      = options[:name]
      @attribute = options[:attribute].to_sym
    end

    def evaluate(context = {})
      context.fetch(attribute)
    end
  end
end
