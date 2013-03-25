require 'spec_helper'

describe Contact do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:label) }
  end

  describe 'attributes' do
    it { should_not allow_mass_assignment_of(:type) }
    it { should have_readonly_attribute(:uuid) }
  end
end
