require 'spec_helper'

describe NotificationRule do
  describe 'associations' do
    it { should belong_to(:contact) }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_delay) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
  end
end
