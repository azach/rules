require 'spec_helper'

describe Rules::Evaluators do
  describe 'equals' do
    it 'returns true if two objects are the same' do
      Rules::Evaluators.list[:equals].evaluate(1.0, 1.0).should be_true
      Rules::Evaluators.list[:equals].evaluate('romeo', 'romeo').should be_true
      Rules::Evaluators.list[:equals].evaluate(['a', 'b'], ['a', 'b']).should be_true
    end

    it 'returns false if two objects are not the same' do
      Rules::Evaluators.list[:equals].evaluate(1.0, 1.3).should be_false
      Rules::Evaluators.list[:equals].evaluate('romeo', 'juliet').should be_false
      Rules::Evaluators.list[:equals].evaluate(['a', 'b'], ['a', 'c']).should be_false
    end
  end
  
  describe 'not_equals' do
    it 'returns false if two objects are the same' do
      Rules::Evaluators.list[:not_equals].evaluate(1.0, 1.0).should be_false
      Rules::Evaluators.list[:not_equals].evaluate('romeo', 'romeo').should be_false
      Rules::Evaluators.list[:not_equals].evaluate(['a', 'b'], ['a', 'b']).should be_false
    end

    it 'returns true if two objects are not the same' do
      Rules::Evaluators.list[:not_equals].evaluate(1.0, 1.3).should be_true
      Rules::Evaluators.list[:not_equals].evaluate('romeo', 'juliet').should be_true
      Rules::Evaluators.list[:not_equals].evaluate(['a', 'b'], ['a', 'c']).should be_true
    end
  end
  
  describe 'nil' do
    it 'returns true if an object is nil' do
      Rules::Evaluators.list[:nil].evaluate(nil).should be_true      
    end

    it 'returns false if an object is not nil' do
      Rules::Evaluators.list[:nil].evaluate(stub('real')).should be_false
    end
  end
end
