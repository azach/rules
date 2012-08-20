require 'spec_helper'

describe Rules::Evaluators do
  describe '.define_evaluator' do
    it 'fails if the key already exists' do
      Rules::Evaluators.define_evaluator :duplicate
      expect {
        Rules::Evaluators.define_evaluator :duplicate
      }.to raise_error('Evaluator already exists')
    end

    it 'creates a new evaluator object' do
      evaluator = Rules::Evaluators.define_evaluator :create
      evaluator.should be_instance_of(Rules::Evaluators::Evaluator)
    end

    it 'sets the properties of the evaluator' do
      evaluator = Rules::Evaluators.define_evaluator :set do
        self.evaluation_method = ->(lhs, rhs) { lhs == rhs }
        self.name = 'some name'
      end
      evaluator.evaluation_method.should_not be_nil
      evaluator.name.should == 'some name'
    end

    it 'adds the evaluator to a hash of evaluators' do
      expect {
        Rules::Evaluators.define_evaluator :add
      }.to change { Rules::Evaluators.list[:add] }.from(nil)
    end
  end
end
