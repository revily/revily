require 'spec_helper'

describe PolicyRule do
  describe 'associations' do
    it { should belong_to(:policy) }
    it { should belong_to(:assignable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:escalation_timeout) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
  end
end
