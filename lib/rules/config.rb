require 'singleton'

class Rules::Config
  include Singleton

  attr_accessor :errors_are_false, :missing_attributes_are_nil

  def initialize
    self.errors_are_false           = true
    self.missing_attributes_are_nil = true
  end

  def missing_attributes_are_nil?
    !!missing_attributes_are_nil
  end

  def errors_are_false?
    !!errors_are_false
  end
end
