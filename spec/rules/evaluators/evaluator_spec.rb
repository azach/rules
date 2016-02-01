require 'spec_helper'

describe Rules::Evaluators::Evaluator do
  describe '#evaluate' do
    let(:evaluator) { Rules::Evaluators::Evaluator.new(:test) }
    let(:lhv) { 'lhv' }
    let(:rhv) { 'rhv' }

    it 'raises an error if a block is not defined' do
      expect {
        evaluator.evaluate(lhv, rhv)
      }.to raise_error 'Unknown evaluation method'
    end

    it 'calls the block for the evaluator with the specified' do
      evaluator.evaluation_method = ->(lhv, rhv) { true }
      evaluator.evaluation_method.should_receive(:call).with(lhv, rhv)
      evaluator.evaluate(lhv, rhv)
    end

    context 'when an error is raised within the evaluator' do
      before { evaluator.evaluation_method = ->(lhv, rhv) { raise 'oh noes' } }

      it 'returns false by default' do
        evaluator.evaluate(lhv, rhv).should be_falsey
      end

      it 'raises the error if the errors_are_false config option is false' do
        Rules.config.stub(errors_are_false?: false)
        expect {
          evaluator.evaluate(lhv, rhv)
        }.to raise_error 'oh noes'
      end
    end
  end
end
