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

  describe '#evaluate' do
    let(:true_rule1) { Rules::Rule.new(lhs_parameter_key: 'today', evaluator_key: 'not_nil') }
    let(:true_rule2) { Rules::Rule.new(lhs_parameter_key: nil, evaluator_key: 'nil') }
    let(:false_rule1) { Rules::Rule.new(lhs_parameter_key: 'today', evaluator_key: 'nil') }
    let(:false_rule2) { Rules::Rule.new(lhs_parameter_key: nil, evaluator_key: 'not_nil') }

    it 'returns true if there are no rules' do
      rule_set.evaluate.should be_true
    end

    context 'when evaluation logic is all' do
      before { rule_set.evaluation_logic = 'all' }

      it 'returns true if all rules are true' do
        rule_set.rules << [true_rule1, true_rule2]
        rule_set.evaluate.should be_true
      end

      it 'returns false if any rules are false' do
        rule_set.rules << [true_rule1, false_rule1]
        rule_set.evaluate.should be_false
      end
    end

    context 'when evaluation logic is any' do
      before { rule_set.evaluation_logic = 'any' }

      it 'returns true if all rules are true' do
        rule_set.rules << [true_rule1, true_rule2]
        rule_set.evaluate.should be_true
      end

      it 'returns true if a single rule is true' do
        rule_set.rules << [false_rule1, true_rule1]
        rule_set.evaluate.should be_true
      end

      it 'returns false if all rules are false' do
        rule_set.rules << [false_rule1, false_rule2]
        rule_set.evaluate.should be_false
      end
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
