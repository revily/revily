require 'spec_helper'

describe Policy do
  pause_events!

  context 'associations' do
    it { expect(subject).to belong_to(:account) }
    it { expect(subject).to have_many(:policy_rules) }
    it { expect(subject).to have_many(:service_policies) }
    it { expect(subject).to have_many(:services).through(:service_policies) }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of(:name) }
  end

  context 'attributes' do
    it { expect(subject).to have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      expect(obj.to_param).to eq obj.uuid
    end
  end
end
