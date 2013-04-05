require 'spec_helper'

describe ServiceEscalationPolicy do
  describe 'associations' do
    it { should belong_to(:service) }
    it { should belong_to(:escalation_policy) }
  end

  it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
end
