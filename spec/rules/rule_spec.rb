require 'spec_helper'

describe Rules::Rule do
  let (:evaluator) { :equals }
  let (:lhs) { Rules::Parameters::Base.new(value: 'lhs') }
  let (:rhs) { Rules::Parameters::Base.new(value: 'rhs') }

  describe '#new' do
    it 'requires a valid evaluator' do
      expect {
        Rules::Rule.new(:fake, nil, nil)
      }.to raise_error('Invalid evaluator')
    end

    it 'requires a lhs parameter' do
      expect {
        Rules::Rule.new(evaluator, nil, nil)
      }.to raise_error(ArgumentError)
    end

    it 'requires a rhs parameter if the evaluator requires one' do
      expect {
        Rules::Rule.new(evaluator, lhs, nil)
      }.to raise_error(ArgumentError)
    end

    it 'does not require a rhs parameter if the evaluator does not require one' do
      Rules::Evaluators.list[evaluator].stub(:requires_rhs?).and_return(false)
      expect {
        Rules::Rule.new(evaluator, lhs, nil)
      }.not_to raise_error(ArgumentError)
    end
  end

  describe '#evaluate' do
  end
end