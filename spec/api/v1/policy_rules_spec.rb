require 'spec_helper'

describe 'policy_rules' do
  sign_in_user
  let(:policy) { create(:policy, account: account) }

  describe 'GET /policies/:policy_id/rules' do
    let!(:rule) { create(:policy_rule, policy: policy, assignment_id: user.uuid) }
    before { get "/policies/#{policy.uuid}/rules" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to have_json_size(1) }
    it { expect(body).to be_json_eql serializer([rule]) }
  end

  describe 'GET /policies/:policy_id/rules/:id' do
    let(:rule) { create(:policy_rule, policy: policy, assignment_id: user.uuid) }
    before { get "/policies/#{policy.uuid}/rules/#{rule.uuid}" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(rule) }
  end

  describe 'POST /policies:policy_id/rules', :focus do
    let(:assignment) { create(:user, account: account) }
    let(:attributes) { attributes_for(:policy_rule, policy: policy, assignment_id: assignment.uuid) }
    before { puts attributes.inspect }
    before { post "/policies", attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  describe 'PATCH /policies/:policy_id/rules/:id' do
    before { patch "/policies/#{policy.uuid}", attributes_for(:policy).to_json }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

  describe 'DELETE /policies/:policy_id/rules/:id' do
    before { delete "/policies/#{policy.uuid}" }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

end
 