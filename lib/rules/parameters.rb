module Rules
  module Parameters
    require 'rules/parameters/parameter'
    require 'rules/parameters/attribute'
    require 'rules/parameters/constant'

    @@constants ||= {}

    def self.constants
      @@constants
    end

    def self.define_constant(key, &block)
      raise "Constant #{key} already exists" if @@constants[key]
      constant = Constant.new(key)
      constant.instance_eval(&block) if block_given?
      @@constants[key] = constant
    end
  end
end
