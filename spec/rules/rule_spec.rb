require 'spec_helper'

describe Rules::Rule do
  let (:evaluator) { :equals }
  let (:lhs) { stub('lhs param') }
  let (:rhs) { stub('rhs param') }

  describe 'validations' do
    it 'requires a valid evaluator' do
      rule = Rules::Rule.new(evaluator: 'fake', lhs_parameter: nil, rhs_parameter: nil)
      rule.should_not be_valid
      rule.errors[:evaluator].should include("can't be blank")
    end

    it 'requires a lhs parameter' do
      rule = Rules::Rule.new(evaluator: evaluator, lhs_parameter: nil, rhs_parameter: nil)
      rule.should_not be_valid
      rule.errors[:lhs_parameter].should include("can't be blank")
    end

    it 'requires a rhs parameter if the evaluator requires one' do
      rule = Rules::Rule.new(evaluator: evaluator, lhs_parameter: lhs, rhs_parameter: nil)
      rule.should_not be_valid
      rule.errors[:rhs_parameter].should include("can't be blank")
    end

    it 'does not require a rhs parameter if the evaluator does not require one' do
      Rules::Evaluators.list[evaluator].stub(:requires_rhs?).and_return(false)
      rule = Rules::Rule.new(evaluator: :nil, lhs_parameter: lhs, rhs_parameter: nil)
      rule.should be_valid
    end
  end

  describe '#evaluate' do
  end
end