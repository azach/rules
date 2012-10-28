require 'singleton'

class Rules::Config
  include Singleton

  attr_accessor :errors_are_false

  def initialize
    self.errors_are_false = true
  end

  def errors_are_false?
    !!errors_are_false
  end
end
