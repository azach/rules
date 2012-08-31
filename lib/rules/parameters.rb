module Rules
  module Parameters
    require 'rules/parameters/constant'

    @@constants ||= {}

    def self.constants
      @@constants
    end

    def self.define_constant(key, &block)
      raise 'Constant already exists' if @@constants[key]
      constant = Constant.new(key)
      constant.instance_eval(&block) if block_given?
      @@constants[key] = constant
    end

    class Attribute
      attr_reader :context

      def initialize(options = {})
        @method_chain = options[:attributes] || Array.wrap(options[:attribute])
        @object = options[:object]
        @context = options[:context]
        raise 'Can not specify a context and an object' if @object && @context
      end

      def evaluate(contexts = {})
        raise 'Must specify an attribute to evaluate on the object' if @method_chain.blank?
        raise 'Object has already been defined' if @object && contexts[@context]
        object = @object || contexts[@context]
        @method_chain.each do |method|
          raise 'Object does not respond to method' unless object.respond_to?(method.to_sym)
          object = object.send(method.to_sym)
        end
        object
      end
    end
  end
end