require 'spec_helper'

describe Service do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:incidents) }
    it { should have_many(:alerts).through(:incidents) }
    it { should have_one(:service_policy) }
    it { should have_one(:policy).through(:service_policy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:auto_resolve_timeout) }
    it { should validate_presence_of(:acknowledge_timeout) }
    it { should validate_presence_of(:state) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      obj.to_param.should == obj.uuid
    end
  end
end
