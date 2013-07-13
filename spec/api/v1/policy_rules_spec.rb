require 'spec_helper'

describe 'policy_rules' do
  sign_in_user
  let(:policy) { create(:policy, account: account) }
  let(:assignment_attributes) { { id: user.uuid, type: "User" } }

  describe 'GET /policies/:policy_id/rules' do
    context 'valid' do
      let!(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      before { get "/policies/#{policy.uuid}/rules" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it { expect(body).to have_json_size(1) }
      it { expect(body).to be_json_eql serializer([rule]) }
    end

    context 'none' do
      before { get "/policies/#{policy.uuid}/rules" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it { expect(body).to have_json_size(0) }
      it { expect(body).to be_json_eql([]) }
    end
  end

  describe 'GET /policies/:policy_id/rules/:id' do
    context 'valid' do
      let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      before { get "/policies/#{policy.uuid}/rules/#{rule.uuid}" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it { expect(body).to be_json_eql serializer(rule) }
    end

    context 'not found' do
      before { get "/policies/#{policy.uuid}/rules/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body }
    end
  end

  describe 'POST /policies:policy_id/rules' do
    let(:attributes) { attributes_for(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
    before { post "/policies/#{policy.uuid}/rules", attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  describe 'PATCH /policies/:policy_id/rules/:id' do
    context 'valid' do
      let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      let(:attributes) { { escalation_timeout: 30 } }
      before { patch "/policies/#{policy.uuid}/rules/#{rule.uuid}", attributes.to_json }

      it { should respond_with(:no_content) }
      it { should_not have_body }
      it { expect(rule.reload.escalation_timeout).to eq 30 }
    end

    context 'not found' do
      before { patch "/policies/#{policy.uuid}/rules/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body }
    end
  end

  describe 'DELETE /policies/:policy_id/rules/:id' do
    context 'valid' do
      let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      before { delete "/policies/#{policy.uuid}/rules/#{rule.uuid}" }

      it { should respond_with(:no_content) }
      it { should_not have_body }
      it { expect(get "/policies/#{policy.uuid}/rules/#{rule.uuid}").to respond_with(:not_found)  }
    end

    context 'not found' do
      before { delete "/policies/#{policy.uuid}/rules/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body}
    end
  end

end
 