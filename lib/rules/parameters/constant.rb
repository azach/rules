require 'rules/parameters/parameter'

module Rules::Parameters
  class Constant < Parameter
    attr_accessor :evaluation_method, :casting_method, :input_type

    def initialize(key)
      self.name = key.to_s
    end

    def evaluate(context = {})
      raise 'Unknown evaluation method' unless evaluation_method
      evaluation_method.call
    end

    def input_type
      @input_type || :string
    end

    def cast(value)
      return value unless casting_method
      casting_method.call(value)
    end
  end
end
