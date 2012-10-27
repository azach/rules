require 'spec_helper'

describe Rules::Rule do
  let(:rule_set) { Rules::RuleSet.new }
  let(:evaluator) { 'equals' }
  let(:lhs) { 'today' }
  let(:rhs) { Date.today.to_s }

  describe 'validations' do
    it 'requires a valid evaluator' do
      rule = Rules::Rule.new(evaluator: 'fake', lhs_parameter: nil, rhs_parameter: nil)
      rule.should_not be_valid
      rule.errors[:evaluator].should include("is not included in the list")
    end

    it 'requires a lhs parameter' do
      rule = Rules::Rule.new(evaluator: evaluator, lhs_parameter: nil, rhs_parameter: nil)
      rule.should_not be_valid
      rule.errors[:lhs_parameter].should include("is not included in the list")
    end

    it 'requires a valid lhs parameter' do
      rule = Rules::Rule.new(evaluator: evaluator, lhs_parameter: 'fake', rhs_parameter: nil)
      rule.should_not be_valid
      rule.errors[:lhs_parameter].should include("is not included in the list")
    end

    it 'requires a rhs parameter if the evaluator requires one' do
      rule = Rules::Rule.new(evaluator: evaluator, lhs_parameter: lhs, rhs_parameter: nil)
      rule.should_not be_valid
      rule.errors[:rhs_parameter].should include("can't be blank")
    end

    it 'require a blank rhs parameter if the evaluator does not require one' do
      rule = Rules::Rule.new(evaluator: 'nil', lhs_parameter: lhs, rhs_parameter: rhs)
      rule.should_not be_valid
      rule.errors[:rhs_parameter].should include("must be blank for this evaluation method")
    end

    it 'allows a lhs parameter with a valid constant key' do
      rule = Rules::Rule.new(evaluator: 'nil', lhs_parameter: 'today')
      rule.should be_valid
    end

    it 'allows a lhs parameter with a valid attribute key' do
      rule_set.stub(attributes: {current_user: 'The current user'})
      rule = Rules::Rule.new(rule_set: rule_set, evaluator: 'nil', lhs_parameter: 'current_user')
      rule.should be_valid
    end

    it 'is valid for well defined rules' do
      rule = Rules::Rule.new(evaluator: evaluator, lhs_parameter: lhs, rhs_parameter: rhs)
      rule.should be_valid

      rule = Rules::Rule.new(evaluator: 'nil', lhs_parameter: lhs, rhs_parameter: nil)
      rule.should be_valid
    end
  end

  describe '#get_evaluator' do
    it 'returns nil if an evaluator does not exist for a key' do
      rule = Rules::Rule.new(evaluator: 'fake')
      rule.get_evaluator.should be_nil
    end

    it 'returns the evaluator if an evaluator with the key exists' do
      rule = Rules::Rule.new(evaluator: evaluator)
      rule.get_evaluator.should be_kind_of(Rules::Evaluators::Evaluator)
    end
  end

  describe '#lhs_parameter_value' do
    it 'returns nil if the parameter key does not have a corresponding attribute' do
      rule = Rules::Rule.new(lhs_parameter: 'fake')
      rule.lhs_parameter_value.should be_nil
    end

    it 'returns the evaluated attribute for a constant key' do
      rule = Rules::Rule.new(lhs_parameter: 'today')
      rule.lhs_parameter_value.should == Time.now.utc.to_date
    end

    it 'returns the right value for an attribute' do
      current_user = mock('current user')
      current_user_attribute = Rules::Parameters::Attribute.new(key: :current_user, name: 'the current user')
      rule_set.stub(attributes: {current_user: current_user_attribute})

      rule = Rules::Rule.new(rule_set: rule_set, lhs_parameter: 'current_user')

      rule.lhs_parameter_value({
        current_user: current_user,
        current_price: 10
      }).should == current_user
    end

    it 'raises an error if the necessary attributes are not provided for an attribute' do
      current_user_attribute = Rules::Parameters::Attribute.new(key: :current_user, name: 'the current user')
      rule_set.stub(attributes: {current_user: current_user_attribute})

      rule = Rules::Rule.new(rule_set: rule_set, lhs_parameter: 'current_user')

      expect {
        rule.lhs_parameter_value(current_price: 10)
      }.to raise_error KeyError
    end
  end

  describe '#rhs_parameter_value' do
    it 'returns the original value of the lhs parameter does not require a cast' do
      rule = Rules::Rule.new(rhs_parameter: 'some string')
      rule.rhs_parameter_value.should == 'some string'
    end

    it 'raises an error for rhs parameters that can not be cast' do
      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: 'four score and seven years ago')
      expect {
        rule.rhs_parameter_value
      }.to raise_error
    end

    it 'casts the rhs parameter into the format required by the lhs parameter' do
      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: '2012-01-01')
      rule.rhs_parameter_value.should == Date.parse('2012-01-01')
    end
  end

  describe '#lhs_parameter_object' do
    it 'returns nil if the parameter key does not have a corresponding attribute' do
      rule = Rules::Rule.new(lhs_parameter: 'fake')
      rule.lhs_parameter_object.should be_nil
    end

    it 'returns the constant for the parameter key if defined' do
      rule = Rules::Rule.new(lhs_parameter: lhs)
      rule.lhs_parameter_object.should be_kind_of(Rules::Parameters::Constant)
    end

    it 'returns the attribute for the parameter key if defined' do
      rule_set.stub(attributes: {current_user: Rules::Parameters::Attribute.new(key: :current_user)})
      rule = Rules::Rule.new(rule_set: rule_set, lhs_parameter: 'current_user')
      rule.lhs_parameter_object.should be_kind_of(Rules::Parameters::Attribute)
    end
  end

  describe '#evaluate' do
    it 'returns true for rules that meet the conditions' do
      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: Time.now.utc.to_date, evaluator: 'equals')
      rule.evaluate.should be_true

      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: 2.weeks.ago.to_s, evaluator: 'not_equals')
      rule.evaluate.should be_true

      rule_set.stub(attributes: {email_address: Rules::Parameters::Attribute.new(key: :email_address)})
      rule = Rules::Rule.new(lhs_parameter: :email_address, rhs_parameter: /example.com$/, evaluator: 'matches', rule_set: rule_set)
      rule.evaluate(email_address: 'test@example.com').should be_true
    end

    it 'returns false for rules that do not meet the conditions' do
      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: Time.now.utc.to_date, evaluator: 'not_equals')
      rule.evaluate.should be_false

      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: 2.weeks.ago.to_s, evaluator: 'equals')
      rule.evaluate.should be_false

      rule_set.stub(attributes: {email_address: Rules::Parameters::Attribute.new(key: :email_address)})
      rule = Rules::Rule.new(lhs_parameter: :email_address, rhs_parameter: /example.com$/, evaluator: 'not_matches', rule_set: rule_set)
     rule.evaluate(email_address: 'test@example.com').should be_false
    end
  end

  describe '#valid_attributes' do
    it 'returns an empty array with no rule set' do
      rule = Rules::Rule.new
      rule.valid_attributes.should be_empty
    end

    it 'returns an empty array with a rule set with no attributes' do
      rule = Rules::Rule.new(rule_set: rule_set)
      rule.valid_attributes.should be_empty
    end

    it 'returns a list of attributes for a rule set' do
      rule_set.stub(attributes: {current_user: mock('attribute'), order_price: mock('attribute')})
      rule = Rules::Rule.new(rule_set: rule_set)
      rule.should have(2).valid_attributes
    end
  end
end
