require 'spec_helper'

describe User do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:contacts) }
    it { should have_many(:user_schedule_layers) }
    it { should have_many(:schedule_layers).through(:user_schedule_layers) }
    it { should have_many(:escalation_rules) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    # it { should validate_presence_of(:state) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
  end
end
