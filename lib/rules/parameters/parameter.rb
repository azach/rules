module Rules::Parameters
  class Parameter
    VALID_TYPES = [:date, :integer, :float, :boolean, :string, :regexp]

    attr_accessor :name, :type, :key

    def self.cast(value, type)
      return value unless type
      case type
      when :date
        Date.parse(value.to_s)
      when :integer
        value.to_i
      when :float
        value.to_f
      when :boolean
        value.to_s == 'true' ? true : false
      when :string
        value.to_s
      when :regexp
        Regexp.new(value.to_s)
      else
        raise "Don't know how to cast #{type}"
      end
    end

    def initialize(options = {})
      self.key  = options[:key].to_sym
      self.name = options[:name] || options[:key].to_s.humanize
      self.type = options[:type] if options[:type]

      raise "Unknown type #{type}" if type && !VALID_TYPES.include?(type)
    end

    def to_s
      name
    end
  end
end
