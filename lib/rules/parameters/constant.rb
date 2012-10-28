require 'rules/parameters/parameter'

module Rules::Parameters
  class Constant < Parameter
    attr_accessor :evaluation_method

    def evaluate(attributes = {})
      raise 'Unknown evaluation method' unless evaluation_method
      evaluation_method.call
    end
  end
end
