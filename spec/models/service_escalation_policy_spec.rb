require 'spec_helper'

describe ServiceEscalationPolicy do
  context 'associations' do
    it { should belong_to(:service) }
    it { should belong_to(:escalation_policy) }
  end
end
