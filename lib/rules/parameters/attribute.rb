require 'rules/parameters/parameter'

module Rules::Parameters
  class Attribute < Parameter
    def evaluate(attributes = {})
      if Rules.config.missing_attributes_are_nil?
        attributes[key]
      else
        attributes.fetch(key)
      end
    end
  end
end
