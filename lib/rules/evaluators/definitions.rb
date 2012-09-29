module Rules
  module Evaluators
    define_evaluator :equals do
      self.evaluation_method = ->(lhs, rhs) { lhs == rhs }
      self.requires_rhs = true
    end

    define_evaluator :not_equals do
      self.evaluation_method = ->(lhs, rhs) { lhs != rhs }
      self.name = 'does not equal'
      self.requires_rhs = true
    end

    define_evaluator :contains do
      self.evaluation_method = ->(lhs, rhs) { lhs.include?(rhs) }
      self.name = 'contains'
      self.requires_rhs = true
    end

    define_evaluator :not_contains do
      self.evaluation_method = ->(lhs, rhs) { !lhs.include?(rhs) }
      self.name = 'does not contain'
    end

    define_evaluator :nil do
      self.evaluation_method = ->(lhs) { lhs.nil? }
      self.name = 'exists'
      self.requires_rhs = false
    end

    define_evaluator :not_nil do
      self.evaluation_method = ->(lhs) { !lhs.nil? }
      self.name = 'does not exist'
      self.requires_rhs = false
    end

    define_evaluator :matches do
      self.evaluation_method = ->(lhs) { !!(lhs =~ rhs) }
      self.name = 'matches'
      self.requires_rhs = false
    end
  end
end
