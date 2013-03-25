require 'spec_helper'

describe EscalationRule do
  describe 'associations' do
    it { should belong_to(:escalation_policy) }
    it { should belong_to(:assignable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:escalation_timeout) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
  end
end
