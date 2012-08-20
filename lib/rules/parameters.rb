module Rules
  module Parameters
    class Base
      attr_reader :raw_value

    	def initialize(options = {})
    	  @raw_value = options[:value]
    	end

    	def evaluate(val = raw_value)
    	  raise 'Raw value has already defined' if raw_value && val != raw_value
      end
    end

    class String < Base
      def evaluate(val = raw_value)
        super
    	  val.to_s
    	end
    end

    class Number < Base
      def evaluate(val = raw_value)
        super
    	  val.to_i
    	end
    end

    class Regexp < Base
      def evaluate(val = raw_value)
        super
  	    ::Regexp.new(val.to_s)
    	end
    end

    class Attribute < Base
      attr_reader :method_chain

      def initialize(options = {})
        @method_chain = options[:attributes] || [options[:attribute]]
        super
      end

      def evaluate(val = raw_value)
        super
        method_chain.each do |method|
          raise "Object does not respond to method" unless val.respond_to?(method.to_sym)
          val = val.send(method.to_sym)
        end
        val
      end
    end
  end
end