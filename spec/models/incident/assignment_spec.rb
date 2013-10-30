require 'spec_helper'

describe Incident::Assignment do
  pause_events!

  let(:account)       { mock_model("Account") }
  let(:user_1)        { mock_model("User", account: account) }
  let(:user_2)        { mock_model("User", account: account) }
  let(:policy)        { mock_model("Policy", account: account, loop_limit: 2) }
  let(:policy_rule_1) { build_stubbed(:policy_rule, policy: policy, assignment: user_1, position: 1) }
  let(:policy_rule_2) { build_stubbed(:policy_rule, policy: policy, assignment: user_2, position: 2) }
  let(:policy_rules)  { [ policy_rule_1, policy_rule_2 ] }
  let(:service)       { build_stubbed(:service, policy: policy, account: account) }
  let(:incident)      { build_stubbed(:incident, account: account, service: service) }

  let(:assignment)    { described_class.new(incident: incident) }

  before do
    allow(incident).to receive(:service) { service }
    allow(incident).to receive(:policy) { policy }
    allow(policy).to receive(:policy_rules) { policy_rules }
    allow(policy.policy_rules).to receive(:first) { policy_rule_1 }
    allow(policy_rule_1).to receive(:current_user) { user_1 }
    allow(policy_rule_2).to receive(:current_user) { user_2 }
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
    allow(incident.current_policy_rule).to receive(:lower_item) { nil }

    incident.assign

    expect(incident.current_user).to eq user_1
    expect(incident.current_policy_rule).to eq policy_rule_1
    expect(incident.escalation_loop_count).to eq 2

  end

  it "stops assigning if the escalation_loop_count matches policy.loop_limit" do
    allow(incident).to receive(:policy) { policy }
    allow(incident).to receive(:escalation_loop_count) { 2 }
    allow(incident).to receive(:current_policy_rule) { policy_rule_2 }
    allow(incident).to receive(:current_user) { user_2 }
    allow(incident.current_policy_rule).to receive(:lower_item)

    incident.assign

    expect(incident.current_user).to eq user_2
    expect(incident.current_policy_rule).to eq policy_rule_2
    expect(incident.escalation_loop_count).to eq 2
    expect(assignment).to have(1).error_on(:incident)
  end

  context "validations" do
    let(:assignment) { described_class.new(incident: incident) }

    it "validates existence of service" do
      allow(assignment).to receive(:service)
      allow(assignment).to receive(:policy) { policy }
      allow(assignment).to receive(:policy_rules) { policy_rules }

      assignment.valid?
      expect(assignment).to have(1).error_on(:incident)
    end

    it "validates existence of policy" do
      allow(assignment).to receive(:service) { service }
      allow(assignment).to receive(:policy)
      allow(assignment).to receive(:policy_rules) { policy_rules }

      assignment.valid?
      expect(assignment).to have(1).error_on(:incident)
    end

    it "validates existence of at least one policy rule" do

      allow(assignment).to receive(:service) { service }
      allow(assignment).to receive(:policy) { policy }
      allow(assignment).to receive(:policy_rules) { [] }

      assignment.valid?
      expect(assignment).to have(1).error_on(:incident)
    end
  end
end
