module Rules
  module Parameters
    class Constant
      attr_accessor :evaluation_method, :casting_method, :name, :input_type

      def initialize(key)
        name = key.to_s
      end

      def evaluate(context = {})
        raise 'Unknown evaluation method' unless evaluation_method
        evaluation_method.call
      end

      def to_s
        name
      end

      def input_type
        @input_type || :string
      end

      def cast(value)
        return value unless :casting_method
        casting_method.call(value)
      end
    end
  end
end
