require 'spec_helper'

describe Rules::Rule do
  let (:evaluator) { 'equals' }
  let (:lhs) { 'today' }
  let (:rhs) { Date.today.to_s }

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

    it 'returns the evaluated attribute for the parameter key' do
      rule = Rules::Rule.new(lhs_parameter: 'today')
      rule.lhs_parameter_value.should == Time.now.utc.to_date
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

    it 'returns the attribute for the parameter key' do
      rule = Rules::Rule.new(lhs_parameter: lhs)
      rule.lhs_parameter_object.should be_kind_of(Rules::Parameters::Constant)
    end
  end

  describe '#evaluate' do
    it 'returns true for rules that meet the conditions' do
      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: Time.now.utc.to_date, evaluator: 'equals')
      rule.evaluate.should be_true

      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: 2.weeks.ago.to_s, evaluator: 'not_equals')
      rule.evaluate.should be_true

      rule = Rules::Rule.new(lhs_parameter: 'random', rhs_parameter: 1000, evaluator: 'less_than')
      rule.evaluate.should be_true
    end

    it 'returns false for rules that do not meet the conditions' do
      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: Time.now.utc.to_date, evaluator: 'not_equals')
      rule.evaluate.should be_false

      rule = Rules::Rule.new(lhs_parameter: 'today', rhs_parameter: 2.weeks.ago.to_s, evaluator: 'equals')
      rule.evaluate.should be_false

      rule = Rules::Rule.new(lhs_parameter: 'random', rhs_parameter: 1000, evaluator: 'greater_than')
      rule.evaluate.should be_false
    end
  end
end
