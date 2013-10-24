require 'spec_helper'

describe Account do
  pause_events!
  
  context 'associations' do
    it { should have_many(:events) }
    it { should have_many(:hooks) }
    it { should have_many(:incidents) }
    it { should have_many(:policies) }
    it { should have_many(:policy_rules) }
    it { should have_many(:schedule_layers) }
    it { should have_many(:schedules) }
    it { should have_many(:users) }
    it { should have_many(:services) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'attributes' do
  end
end
