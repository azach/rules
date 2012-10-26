require 'spec_helper'

describe Rules::Parameters::Attribute do
  let (:user) do
    stub('user', name: 'terry').tap do |u|
      u.stub_chain(:account, :balance).and_return(100)
    end
  end

  describe '#evaluate' do
  end
end
