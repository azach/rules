module Rules
  module Parameters
    define_constant :today do
      self.name = 'current date'
      self.input_type = :date_select
      self.evaluation_method = -> { Time.now.utc.to_date }
      self.casting_method = ->(value) { value.is_a?(Date) ? value : Date.parse(value.to_s) }
    end

    define_constant :day_of_week do
      self.name = 'day of week'
      self.evaluation_method = -> { Date::DAYNAMES[Time.now.utc.to_date.wday] }
    end
  end
end
