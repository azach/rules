module Rules::Parameters
  class Attribute
    attr_reader :attribute

    def initialize(options = {})
      @attribute = options[:attribute]
    end

    def evaluate(context = {})
      context[@attribute]
    end

    def cast
      raise NotImplementedError
    end
  end
end
