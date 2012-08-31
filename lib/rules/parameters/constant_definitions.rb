module Rules
  module Parameters
    define_constant :today do
      self.evaluation_method = -> { Date.utc_today }
    end

    define_constant :now do
      self.evaluation_method = -> { Time.now.utc }
    end

    define_constant :random do
      self.evaluation_method = -> { Kernel.rand }
    end
  end
end
