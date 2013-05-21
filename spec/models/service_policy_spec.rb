require 'spec_helper'

describe ServicePolicy do
  describe 'associations' do
    it { should belong_to(:service) }
    it { should belong_to(:policy) }
  end

  it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
end
