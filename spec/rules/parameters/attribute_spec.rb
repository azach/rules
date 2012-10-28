require 'spec_helper'

describe Rules::Parameters::Attribute do
  let (:user) do
    stub('user', name: 'terry').tap do |u|
      u.stub_chain(:account, :balance).and_return(100)
    end
  end

  let(:attribute) { Rules::Parameters::Attribute.new(key: 'test_key') }

  describe '#evaluate' do

    it 'retrieves the attribute value from the given hash' do
      attribute.evaluate(key_1: 1, key_2: 'john', test_key: 'carol').should == 'carol'
    end

    context 'when the attribute is missing' do
      it 'returns nil by default' do
        attribute.evaluate(key_1: 1, key_2: 'john').should be_nil
      end

      it 'raises an error if set in the configuration settings' do
        Rules.config.stub(missing_attributes_are_nil?: false)

        expect {
          attribute.evaluate(key_1: 1, key_2: 'john')
        }.to raise_error KeyError
      end
    end
  end
end
