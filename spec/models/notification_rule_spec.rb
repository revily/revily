require 'spec_helper'

describe NotificationRule do
  context 'associations' do
    it { should belong_to(:contact) }
  end

  context 'validations' do
    it { should validate_presence_of(:start_delay) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
  end
end
