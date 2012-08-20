require 'spec_helper'

describe Rules::Parameters do
  let (:user) do
    stub('user').tap do |u|
      u.stub(:name).and_return('terry')
      u.stub_chain(:account, :balance).and_return(100)
    end
  end

  describe Rules::Parameters::Attribute do
    describe '#evaluate' do
      it 'returns the value of the passed in object for the given attribute' do
        rule = Rules::Parameters::Attribute.new(value: user, attribute: :name)
        rule.evaluate.should == 'terry'
      end

      it 'returns the value of the passed in object for the given attribute chain' do
        rule = Rules::Parameters::Attribute.new(value: user, attributes: [:account, :balance])
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
        rule = Rules::Parameters::Attribute.new(value: stub('second user'), attribute: :name)
        expect {
          rule.evaluate(user)
        }.to raise_error('Raw value has already defined')
      end
    end
  end
end
