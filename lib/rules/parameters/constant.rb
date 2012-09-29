module Rules
  module Parameters
    class Constant
      attr_accessor :evaluation_method

      def initialize(key)
        @name = key.to_s
      end

      def evaluate(context = {})
        raise 'Unknown evaluation method' unless evaluation_method
        evaluation_method.call
      end
      
      def to_s
        @name
      end
    end
  end
end
