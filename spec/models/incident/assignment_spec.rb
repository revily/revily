require 'spec_helper'

describe Incident::Assignment do
  pause_events!

  let(:account)       { build_stubbed(:account) }
  let(:user_1)        { build_stubbed(:user, account: account) }
  let(:user_2)        { build_stubbed(:user, account: account) }
  let(:policy)        { build_stubbed(:policy, account: account, loop_limit: 2) }
  let(:policy_rule_1) { build_stubbed(:policy_rule, policy: policy, assignment: user_1, position: 1) }
  let(:policy_rule_2) { build_stubbed(:policy_rule, policy: policy, assignment: user_2, position: 2) }
  let(:policy_rules)  { [ policy_rule_1, policy_rule_2 ] }
  let(:service)       { build_stubbed(:service, policy: policy, account: account) }
  let(:incident)      { build_stubbed(:incident, account: account, service: service) }
   
  let(:assignment)    { described_class.new(incident: incident) }

  before do
    incident.stub(
      service: service,
      policy: policy
    )
    policy.stub(policy_rules: policy_rules)
    policy.policy_rules.stub(first: policy_rule_1)
    policy_rule_1.stub(current_user: user_1)
    policy_rule_2.stub(current_user: user_2)
  end

  it "assigns the first policy and user on a new incident" do
    expect(incident.current_user).to be_nil
    expect(incident.current_policy_rule).to be_nil
    expect(incident.escalation_loop_count).to be_zero

    incident.assign

    expect(incident.current_user).to eq user_1
    expect(incident.current_policy_rule).to eq policy_rule_1
    expect(incident.escalation_loop_count).to eq 1
  end

  it "assigns the next policy rule and user in order" do
    incident.escalation_loop_count = 1
    incident.current_policy_rule = policy_rule_1
    incident.current_policy_rule.stub(lower_item: policy_rule_2)

    incident.assign

    expect(incident.current_user).to eq user_2
    expect(incident.current_policy_rule).to eq policy_rule_2
    expect(incident.escalation_loop_count).to eq 1
  end

  it "loops back to the first policy rule" do
    incident.escalation_loop_count = 1
    incident.current_policy_rule = policy_rule_2
    incident.current_user = user_2
    incident.current_policy_rule.stub(lower_item: nil)

    incident.assign

    expect(incident.current_user).to eq user_1
    expect(incident.current_policy_rule).to eq policy_rule_1
    expect(incident.escalation_loop_count).to eq 2

  end

  it "stops assigning if the escalation_loop_count matches policy.loop_limit" do
    incident.stub(
      policy: policy,
      escalation_loop_count: 2,
      current_policy_rule: policy_rule_2,
      current_user: user_2
    )
    incident.current_policy_rule.stub(lower_item: nil)
    
    incident.assign

    expect(incident.current_user).to eq user_2
    expect(incident.current_policy_rule).to eq policy_rule_2
    expect(incident.escalation_loop_count).to eq 2
    expect(assignment).to have(1).error_on(:incident)
  end

  context "validations" do
    let(:assignment) { described_class.new(incident: incident) }

    it "validates existence of service" do
      assignment.stub(service: nil, policy: policy, policy_rules: policy_rules)

      assignment.valid?
      expect(assignment).to have(1).error_on(:incident)
    end

    it "validates existence of policy" do
      assignment.stub(service: service, policy: nil, policy_rules: policy_rules)

      assignment.valid?
      expect(assignment).to have(1).error_on(:incident)
    end

    it "validates existence of at least one policy rule" do
      assignment.stub(service: service, policy: policy, policy_rules: [])

      assignment.valid?
      expect(assignment).to have(1).error_on(:incident)
    end
  end
end