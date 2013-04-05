require 'spec_helper'

describe EscalationPolicy do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:escalation_rules) }
    it { should have_many(:service_escalation_policies) }
    it { should have_many(:services).through(:service_escalation_policies) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
  end
end
