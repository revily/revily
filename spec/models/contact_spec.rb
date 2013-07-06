require 'spec_helper'

describe Contact do
  describe 'associations' do
    it { should belong_to(:contactable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:label) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      contact = create(:sms_contact)
      contact.to_param.should == contact.uuid
    end
  end
end
