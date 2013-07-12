require 'spec_helper'

describe PolicyRule do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  let(:schedule) { create(:schedule, account: account) }
  let(:policy) { create(:policy, account: account) }

  it 'associations' do
    subject.stub(:assignment_attributes).and_return({ id: user.uuid, type: "User" })
    subject.stub(:policy).and_return(policy)
    should belong_to(:policy)
    should belong_to(:assignment)
  end

  it 'validations' do
    subject.stub(:assignment_attributes).and_return({ id: user.uuid, type: "User" })
    subject.stub(:policy).and_return(policy)
    should validate_presence_of(:escalation_timeout)
    # it 'assignment not found'
    # it 'assignment not unique'
  end

  it 'attributes' do
    subject.stub(:assignment_attributes).and_return({ id: user.uuid, type: "User" })
    subject.stub(:policy).and_return(policy)
    subject.should have_readonly_attribute(:uuid)

    obj = build(:policy_rule, policy: policy)
    obj.save(:validate => false)
    obj.to_param.should == obj.uuid
  end

  describe '#assignment_attributes=' do
    it 'finds and associates the appropriate user' do
      policy_rule = build(:policy_rule, policy: policy, assignment_attributes: { id: user.uuid, type: "User" })
      policy_rule.save
      expect(policy_rule.assignment_type).to eq "User"
      expect(policy_rule.assignment_id).to eq user.id
    end

    it 'finds and associates the appropriate schedule' do
      policy_rule = build(:policy_rule, policy: policy, assignment_attributes: { id: schedule.uuid, type: "Schedule" })
      policy_rule.save
      expect(policy_rule.assignment_type).to eq "Schedule"
      expect(policy_rule.assignment_id).to eq schedule.id
    end

  end
end
