require 'spec_helper'

describe Rules::Rule do
  let(:rule_set) { Rules::RuleSet.new }
  let(:evaluator_key) { 'equals' }
  let(:lhs) { 'today' }
  let(:rhs_key) { 'today' }
  let(:rhs_raw) { Date.today.to_s }

  describe 'validations' do
    it 'requires a valid evaluator' do
      rule = Rules::Rule.new(evaluator_key: 'fake')
      rule.should_not be_valid
      rule.errors[:evaluator_key].should include("is not included in the list")
    end

    it 'requires a lhs parameter' do
      rule = Rules::Rule.new(evaluator_key: evaluator_key)
      rule.should_not be_valid
      rule.errors[:lhs_parameter_key].should include("is not a valid parameter")
    end

    it 'requires a valid lhs parameter' do
      rule = Rules::Rule.new(evaluator_key: evaluator_key, lhs_parameter_key: 'fake')
      rule.should_not be_valid
      rule.errors[:lhs_parameter_key].should include("is not a valid parameter")
    end

    it 'requires a rhs parameter if the evaluator requires one' do
      rule = Rules::Rule.new(evaluator_key: evaluator_key, lhs_parameter_key: lhs)
      rule.should_not be_valid
      rule.errors[:rhs_parameter_key].should include("can't be blank")
    end

    it 'requires a blank rhs parameter if the evaluator does not require one' do
      rule = Rules::Rule.new(evaluator_key: 'nil', lhs_parameter_key: lhs, rhs_parameter_raw: rhs_raw)
      rule.should_not be_valid
      rule.errors[:rhs_parameter_raw].should include("must be blank")
    end

    it 'requires a valid rhs parameter key if provided' do
      rule = Rules::Rule.new(evaluator_key: evaluator_key, lhs_parameter_key: lhs, rhs_parameter_key: 'fake')
      rule.should_not be_valid
      rule.errors[:rhs_parameter_key].should include("is not a valid parameter")
    end

    it 'requires that only one of the rhs parameter key or raw value are set' do
      rule = Rules::Rule.new(evaluator_key: evaluator_key, lhs_parameter_key: lhs, rhs_parameter_key: rhs_key, rhs_parameter_raw: rhs_raw)
      rule.should_not be_valid
      rule.errors[:rhs_parameter_key].should include("must be blank")
    end

    it 'allows a lhs parameter with a valid constant key' do
      rule = Rules::Rule.new(evaluator_key: 'nil', lhs_parameter_key: 'today')
      rule.should be_valid
    end

    it 'allows a lhs parameter with a valid attribute key' do
      rule_set.stub(attributes: {current_user: 'The current user'})
      rule = Rules::Rule.new(rule_set: rule_set, evaluator_key: 'nil', lhs_parameter_key: 'current_user')
      rule.should be_valid
    end

    it 'is valid for well defined rules' do
      rule = Rules::Rule.new(evaluator_key: evaluator_key, lhs_parameter_key: lhs, rhs_parameter_raw: rhs_raw)
      rule.should be_valid

      rule = Rules::Rule.new(evaluator_key: evaluator_key, lhs_parameter_key: lhs, rhs_parameter_key: rhs_key)
      rule.should be_valid

      rule = Rules::Rule.new(evaluator_key: 'nil', lhs_parameter_key: lhs)
      rule.should be_valid
    end
  end

  describe '#evaluator' do
    it 'returns nil if an evaluator does not exist for a key' do
      rule = Rules::Rule.new(evaluator_key: 'fake')
      rule.evaluator.should be_nil
    end

    it 'returns the evaluator if an evaluator with the key exists' do
      rule = Rules::Rule.new(evaluator_key: evaluator_key)
      rule.evaluator.should be_kind_of(Rules::Evaluators::Evaluator)
    end
  end

  describe '#lhs_parameter_value' do
    it 'returns nil if the parameter key does not have a corresponding attribute' do
      rule = Rules::Rule.new(lhs_parameter_key: 'fake')
      rule.lhs_parameter_value.should be_nil
    end

    it 'returns the evaluated attribute for a constant key' do
      rule = Rules::Rule.new(lhs_parameter_key: 'today')
      rule.lhs_parameter_value.should == Time.now.utc.to_date
    end

    it 'returns the right value for an attribute' do
      current_user = double('current user')
      current_user_attribute = Rules::Parameters::Attribute.new(key: :current_user, name: 'the current user')
      rule_set.stub(attributes: {current_user: current_user_attribute})

      rule = Rules::Rule.new(rule_set: rule_set, lhs_parameter_key: 'current_user')

      rule.lhs_parameter_value({
        current_user: current_user,
        current_price: 10
      }).should == current_user
    end
  end

  describe '#rhs_parameter_value' do
    context 'with a raw value' do
      it 'returns the original value of the lhs parameter does not require a cast' do
        rule = Rules::Rule.new(rhs_parameter_raw: 'some string')
        rule.rhs_parameter_value.should == 'some string'
      end

      it 'raises an error for rhs parameters that can not be cast' do
        rule = Rules::Rule.new(lhs_parameter_key: 'today', rhs_parameter_raw: 'four score and seven years ago')
        expect {
          rule.rhs_parameter_value
        }.to raise_error
      end

      it 'casts the rhs parameter into the format required by the lhs parameter' do
        rule = Rules::Rule.new(lhs_parameter_key: 'today', rhs_parameter_raw: '2012-01-01')
        rule.rhs_parameter_value.should == Date.parse('2012-01-01')
      end

      it 'casts the rhs parameter into the format required by the evaluator' do
        rule = Rules::Rule.new(evaluator_key: 'matches', rhs_parameter_raw: 'test$')
        rule.rhs_parameter_value.should == Regexp.new('test$')
      end
    end

    context 'with a parameter key' do
      it 'returns nil if the parameter key does not have a corresponding attribute' do
        rule = Rules::Rule.new(rhs_parameter_key: 'fake')
        rule.rhs_parameter_value.should be_nil
      end

      it 'returns the evaluated attribute for a constant key' do
        rule = Rules::Rule.new(rhs_parameter_key: 'today')
        rule.rhs_parameter_value.should == Time.now.utc.to_date
      end

      it 'returns the right value for an attribute' do
        current_user = double('current user')
        current_user_attribute = Rules::Parameters::Attribute.new(key: :current_user, name: 'the current user')
        rule_set.stub(attributes: {current_user: current_user_attribute})

        rule = Rules::Rule.new(rule_set: rule_set, rhs_parameter_key: 'current_user')

        rule.rhs_parameter_value({
          current_user: current_user,
          current_price: 10
        }).should == current_user
      end
    end
  end

  describe '#lhs_parameter' do
    it 'returns nil if the parameter key does not have a corresponding attribute' do
      rule = Rules::Rule.new(lhs_parameter_key: 'fake')
      rule.lhs_parameter.should be_nil
    end

    it 'returns the constant for the parameter key if defined' do
      rule = Rules::Rule.new(lhs_parameter_key: lhs)
      rule.lhs_parameter.should be_kind_of(Rules::Parameters::Constant)
    end

    it 'returns the attribute for the parameter key if defined' do
      rule_set.stub(attributes: {current_user: Rules::Parameters::Attribute.new(key: :current_user)})
      rule = Rules::Rule.new(rule_set: rule_set, lhs_parameter_key: 'current_user')
      rule.lhs_parameter.should be_kind_of(Rules::Parameters::Attribute)
    end
  end

  describe '#rhs_parameter' do
    context 'with a raw value' do
      it 'returns the raw value' do
        rule = Rules::Rule.new(rhs_parameter_raw: 'value')
        rule.rhs_parameter.should == 'value'
      end
    end

    context 'with a parameter key' do
      it 'returns nil if the parameter key does not have a corresponding attribute' do
        rule = Rules::Rule.new(rhs_parameter_key: 'fake')
        rule.rhs_parameter.should be_nil
      end

      it 'returns the constant for the parameter key if defined' do
        rule = Rules::Rule.new(rhs_parameter_key: rhs_key)
        rule.rhs_parameter.should be_kind_of(Rules::Parameters::Constant)
      end

      it 'returns the attribute for the parameter key if defined' do
        rule_set.stub(attributes: {current_user: Rules::Parameters::Attribute.new(key: :current_user)})
        rule = Rules::Rule.new(rule_set: rule_set, rhs_parameter_key: 'current_user')
        rule.rhs_parameter.should be_kind_of(Rules::Parameters::Attribute)
      end
    end
  end

  describe '#evaluate' do
    let(:email_attribute) { Rules::Parameters::Attribute.new(key: :email_address) }
    let(:name_attribute) { Rules::Parameters::Attribute.new(key: :name) }

    before { rule_set.stub(attributes: {email_address: email_attribute, name: name_attribute}) }

    it 'returns true for rules that meet the conditions' do
      rule = Rules::Rule.new(lhs_parameter_key: 'today', rhs_parameter_raw: Time.now.utc.to_date, evaluator_key: 'equals')
      rule.evaluate.should be_truthy

      rule = Rules::Rule.new(lhs_parameter_key: 'today', rhs_parameter_raw: 2.weeks.ago.to_s, evaluator_key: 'not_equals')
      rule.evaluate.should be_truthy

      rule = Rules::Rule.new(lhs_parameter_key: :email_address, rhs_parameter_raw: /example.com$/, evaluator_key: 'matches', rule_set: rule_set)
      rule.evaluate(email_address: 'test@example.com').should be_truthy

      rule = Rules::Rule.new(lhs_parameter_key: :email_address, rhs_parameter_key: :name, evaluator_key: 'contains', rule_set: rule_set)
      rule.evaluate(email_address: 'sally@example.com', name: 'sally').should be_truthy
    end

    it 'returns false for rules that do not meet the conditions' do
      rule = Rules::Rule.new(lhs_parameter_key: 'today', rhs_parameter_raw: Time.now.utc.to_date, evaluator_key: 'not_equals')
      rule.evaluate.should be_falsey

      rule = Rules::Rule.new(lhs_parameter_key: 'today', rhs_parameter_raw: 2.weeks.ago.to_s, evaluator_key: 'equals')
      rule.evaluate.should be_falsey

      rule = Rules::Rule.new(lhs_parameter_key: :email_address, rhs_parameter_raw: /example.com$/, evaluator_key: 'not_matches', rule_set: rule_set)
      rule.evaluate(email_address: 'test@example.com').should be_falsey

      rule = Rules::Rule.new(lhs_parameter_key: :email_address, rhs_parameter_key: :name, evaluator_key: 'contains', rule_set: rule_set)
      rule.evaluate(email_address: 'sally@example.com', name: 'terry').should be_falsey
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

    it 'returns the right attribute list when the associated rule set is unsaved' do
      rule = Order.new.rule_set.rules.build
      rule.valid_attributes.should_not be_empty
    end

    it 'returns a list of attributes for a rule set' do
      rule_set.stub(attributes: {current_user: double('attribute'), order_price: double('attribute')})
      rule = Rules::Rule.new(rule_set: rule_set)
      rule.should have(2).valid_attributes
    end
  end
end
