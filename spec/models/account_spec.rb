require 'spec_helper'

describe Account do
  describe 'associations' do
    it { should have_many(:users) }
    it { should have_many(:schedules) }
    it { should have_many(:services) }
    it { should have_many(:incidents).through(:services) }
    it { should have_many(:escalation_policies) }
  end

  describe 'validations' do
    it { should validate_presence_of(:subdomain) }
  end

  describe 'attributes' do
  end
end
