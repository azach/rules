module Rules::Parameters
  class Attribute
    attr_reader :context, :method_chain

    def initialize(options = {})
      @method_chain = options[:attributes] || Array.wrap(options[:attribute])
      @context      = options[:context]
      raise 'Attribute parameters must define a context and attributes' unless @context && @method_chain
    end

    def evaluate(context = {})
      raise 'Must specify an attribute to evaluate on the object' if @method_chain.blank?
      object = context[@context]
      raise 'Invalid context given' unless object
      @method_chain.each do |method|
        raise 'Object does not respond to method' unless object.respond_to?(method.to_sym)
        object = object.send(method.to_sym)
      end
      object
    end

    def as_json(options = nil)
      {
        context: context,
        method_chain: method_chain
      }
    end
  end
end
