module Rules::Parameters
  class Parameter
    attr_accessor :name

    def cast(value)
      value
    end

    def to_s
      name
    end
  end
end
