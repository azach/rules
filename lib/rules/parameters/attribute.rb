module Rules::Parameters
  class Attribute
    attr_reader :attribute, :name

    def initialize(options = {})
      @name      = options[:name]
      @attribute = options[:attribute].to_sym
    end

    def evaluate(context = {})
      context.fetch(attribute)
    end

    def cast(value)
      # TODO
      value
    end

    def to_s
      @name
    end
  end
end
