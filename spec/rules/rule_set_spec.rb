require 'spec_helper'

describe Rules::RuleSet do
  let(:rule_set) { Rules::RuleSet.new }
  let(:context) { {context1: {name: 'name of context 1'}, context2: {name: 'name of context 2'}} }

  before { stub_const('FakeClass', Class.new) }

  describe '.set_context_for' do
    it 'returns nil if there are no contexts for the given class' do
      Rules::RuleSet.contexts[FakeClass].should be_nil
    end

    it 'stores the list of contexts for the specified class' do
      Rules::RuleSet.set_context_for(FakeClass, context)
      Rules::RuleSet.contexts[FakeClass].should have(2).contexts
    end
  end

  describe '#contexts' do
    before { Rules::RuleSet.set_context_for(FakeClass, context) }

    it 'returns an empty hash if there is no source' do
      rule_set.contexts.should == {}
    end

    it 'returns an empty hash if the class has no defined contexts' do
      rule_set.stub(source: Object.new)
      rule_set.contexts.should == {}
    end

    it 'returns a list of contexts for its source class' do
      rule_set.stub(source: FakeClass.new)
      rule_set.contexts.should have(2).contexts
    end

    it 'returns the context as an attributized object' do
      rule_set.stub(source: FakeClass.new)
      rule_set.contexts[:context1].should be_kind_of(Rules::Parameters::Attribute)
    end

    it 'stores the attribute and name on the attribute object' do
      rule_set.stub(source: FakeClass.new)
      attribute = rule_set.contexts[:context1]

      attribute.attribute.should == :context1
      attribute.name.should == 'name of context 1'
    end
  end
end
