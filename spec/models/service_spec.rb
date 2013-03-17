require 'spec_helper'

describe Service do
  context 'associations' do
    it { should have_many(:events) }
    it { should have_many(:alerts).through(:events) }
    it { should have_one(:service_escalation_policy) }
    it { should have_one(:escalation_policy).through(:service_escalation_policy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:auto_resolve_timeout) }
    it { should validate_presence_of(:acknowledge_timeout) }
    it { should validate_presence_of(:state) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:uuid) }
  end
end
