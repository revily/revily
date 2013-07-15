require 'spec_helper'

describe Account do
  context 'associations' do
    it { should have_many(:users) }
    it { should have_many(:schedules) }
    it { should have_many(:services) }
    it { should have_many(:incidents).through(:services) }
    it { should have_many(:policies) }
  end

  context 'validations' do
    it { should validate_presence_of(:subdomain) }
  end

  context 'attributes' do
  end
end
