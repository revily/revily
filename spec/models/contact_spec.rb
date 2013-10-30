require 'spec_helper'

describe Contact do
  pause_events!

  context 'associations' do
    it { expect(subject).to belong_to(:user) }
    it { expect(subject).to belong_to(:account) }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of(:type) }
    it { expect(subject).to validate_presence_of(:address) }
    it { expect(subject).to validate_presence_of(:label) }
  end

  context 'attributes' do
    it { expect(subject).to have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      contact = create(:sms_contact)
      expect(contact.to_param).to eq contact.uuid
    end
  end
end
