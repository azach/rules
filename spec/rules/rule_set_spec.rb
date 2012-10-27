require 'spec_helper'

describe Rules::RuleSet do
  let(:rule_set) { Rules::RuleSet.new }
  let(:attributes) { {attribute1: {name: 'name of attribute 1'}, attribute2: {name: 'name of attribute 2'}} }

  before { stub_const('FakeClass', Class.new) }

  describe '.set_attributes_for' do
    it 'returns nil if there are no attributes for the given class' do
      Rules::RuleSet.attributes[FakeClass].should be_nil
    end

    it 'stores the list of attributes for the specified class' do
      Rules::RuleSet.set_attributes_for(FakeClass, attributes)
      Rules::RuleSet.attributes[FakeClass].should have(2).attributes
    end
  end

  describe '#attributes' do
    before { Rules::RuleSet.set_attributes_for(FakeClass, attributes) }

    it 'returns an empty hash if there is no source' do
      rule_set.attributes.should == {}
    end

    it 'returns an empty hash if the class has no defined attributes' do
      rule_set.stub(source: Object.new)
      rule_set.attributes.should == {}
    end

    it 'returns a list of attributes for its source class' do
      rule_set.stub(source: FakeClass.new)
      rule_set.attributes.should have(2).attributes
    end

    it 'returns the attribute as an attributized object' do
      rule_set.stub(source: FakeClass.new)
      rule_set.attributes[:attribute1].should be_kind_of(Rules::Parameters::Attribute)
    end

    it 'stores the key and name on the attribute object' do
      rule_set.stub(source: FakeClass.new)
      attribute = rule_set.attributes[:attribute1]

      attribute.key.should == :attribute1
      attribute.name.should == 'name of attribute 1'
    end
  end
end
