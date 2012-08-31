require 'spec_helper'

describe Rules::Parameters do
  describe Rules::Parameters::Attribute do
    let (:user) do
      stub('user', name: 'terry').tap do |u|
        u.stub_chain(:account, :balance).and_return(100)
      end
    end
    
    describe '#evaluate' do
      it 'returns the value of the passed in object for the given attribute' do
        rule = Rules::Parameters::Attribute.new(object: user, attribute: :name)
        rule.evaluate.should == 'terry'
      end

      it 'returns the value of the passed in object for the given attribute chain' do
        rule = Rules::Parameters::Attribute.new(object: user, attributes: [:account, :balance])
        rule.evaluate.should == 100
      end

      it 'returns the value of the run-time object for the given attribute' do
        rule = Rules::Parameters::Attribute.new(attribute: :name)
        rule.evaluate(user).should == 'terry'
      end

      it 'returns the value of the run-time object for the given attribute chain' do
        rule = Rules::Parameters::Attribute.new(attributes: [:account, :balance])
        rule.evaluate(user).should == 100
      end

      it 'raises an error if an object is defined and one is passed in at run-time' do
        rule = Rules::Parameters::Attribute.new(object: stub('second user'), attribute: :name)
        expect {
          rule.evaluate(user)
        }.to raise_error('Object has already been defined')
      end
    end
  end
end
