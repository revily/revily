require 'spec_helper'

describe PolicyRule do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  let(:schedule) { create(:schedule, account: account) }
  let(:policy) { create(:policy, account: account) }

  describe 'associations' do
    it { should belong_to(:policy) }
    it { should belong_to(:assignable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:escalation_timeout) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class, policy: policy, assignment_id: user.uuid)
      obj.to_param.should == obj.uuid
    end

    describe '#assignment_id=' do
      let(:policy_rule) { build(:policy_rule, policy: policy) }

      it 'finds and associates the appropriate user' do
        policy_rule.assignment_id = user.uuid
        policy_rule.save
        expect(policy_rule.assignable_type).to eq "User"
        expect(policy_rule.assignable_id).to eq user.id
      end

      it 'finds and associates the appropriate schedule' do
        policy_rule.assignment_id = schedule.uuid
        policy_rule.save
        expect(policy_rule.assignable_type).to eq "Schedule"
        expect(policy_rule.assignable_id).to eq schedule.id
      end

      it 
    end
  end
end
