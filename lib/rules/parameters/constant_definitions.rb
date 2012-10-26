module Rules
  module Parameters
    define_constant :today do
      self.name = 'current date'
      self.input_type = :date_select
      self.evaluation_method = -> { Time.now.utc.to_date }
      self.casting_method = ->(value) { value.is_a?(Date) ? value : Date.parse(value.to_s) }
    end

    define_constant :now do
      self.name = 'current time'
      self.input_type = :datetime_select
      self.evaluation_method = -> { Time.now.utc }
      self.casting_method = ->(value) { value.is_a?(DateTime) ? value : DateTime.parse(value.to_s) }
    end

    define_constant :random do
      self.name = 'random number (1-100)'
      self.input_type = :number
      self.evaluation_method = -> { Kernel.rand(100) }
      self.casting_method = ->(value) { value.to_f }
    end
  end
end
