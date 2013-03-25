require 'spec_helper'

describe EscalationPolicy do
  describe 'associations' do
    it { should have_many(:escalation_rules) }
    it { should have_many(:service_escalation_policies) }
    it { should have_many(:services).through(:service_escalation_policies) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
  end
end
