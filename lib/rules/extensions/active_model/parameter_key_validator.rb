class ParameterKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.valid_parameter_keys.include?(value)
      record.errors.add attribute, (options[:message] || "is not a valid parameter")
    end
  end
end
