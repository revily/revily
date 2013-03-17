require 'spec_helper'

describe EscalationPolicy do
  context 'associations' do
    it { should have_many(:escalation_rules) }
    it { should have_many(:services) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:uuid) }
  end
end
