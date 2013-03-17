require 'spec_helper'

describe Event do
  context 'associations' do
    it { should belong_to(:service) }
    it { should have_many(:alerts) }
  end

  context 'validations' do
    it { should validate_presence_of(:message) }
  end

  context 'attributes' do
    it { should serialize(:details) }
    it { should have_readonly_attribute(:uuid) }
  end
end
