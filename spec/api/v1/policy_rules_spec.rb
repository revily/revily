require 'spec_helper'

describe 'policy_rules' do
  sign_in_user
  let(:policy) { create(:policy, account: account) }
  let(:assignment_attributes) { { id: user.uuid, type: "User" } }

  describe 'GET /policies/:policy_id/rules' do
    let!(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
    before { get "/policies/#{policy.uuid}/rules" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to have_json_size(1) }
    it { expect(body).to be_json_eql serializer([rule]) }
  end

  describe 'GET /policies/:policy_id/rules/:id' do
    let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
    before { get "/policies/#{policy.uuid}/rules/#{rule.uuid}" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(rule) }
  end

  describe 'POST /policies:policy_id/rules' do
    let(:attributes) { attributes_for(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
    before { post "/policies/#{policy.uuid}/rules", attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  describe 'PATCH /policies/:policy_id/rules/:id' do
    let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
    let(:attributes) { { escalation_timeout: 30 } }
    before { patch "/policies/#{policy.uuid}/rules/#{rule.uuid}", attributes.to_json }

    it { should respond_with(:no_content) }
    it { should_not have_body }
    it { expect(rule.reload.escalation_timeout).to eq 30 }
  end

  describe 'DELETE /policies/:policy_id/rules/:id' do
    let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
    before { delete "/policies/#{policy.uuid}/rules/#{rule.uuid}" }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

end
 