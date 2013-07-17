require 'spec_helper'

describe Policy do
  context 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:policy_rules) }
    it { should have_many(:service_policies) }
    it { should have_many(:services).through(:service_policies) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
  end
end
