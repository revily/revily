require "spec_helper"

describe "policy_rules" do
  pause_events!
  sign_in_user

  let(:policy) { create(:policy, account: account) }
  let(:assignment_attributes) { { id: user.uuid, type: "User" } }

  describe "GET /api/policies/:policy_id/policy_rules" do
    context "valid" do
      let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      before { policy.reload; get "/api/policies/#{policy.uuid}/policy_rules" }

      it "returns a list of records" do
        expect(last_response).to respond_with(:ok)
        expect(last_response).to have_content_type(:json)
        expect(body["_embedded"]).to have_json_size(1)
      end
    end

    context "none" do
      before { get "/api/policies/#{policy.uuid}/policy_rules" }

      it "returns no records" do
        expect(last_response).to respond_with(:ok)
        expect(last_response).to have_content_type(:json)
        expect(body).to have_json_size(0).at_path("policy_rules")
        expect(body).to be_json_eql([]).at_path("policy_rules")
      end
    end
  end

  describe "GET /api/policies/:policy_id/policy_rules/:id" do
    context "valid" do
      let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      before { get "/api/policies/#{policy.uuid}/policy_rules/#{rule.uuid}" }

      it "returns a record" do
        expect(last_response).to respond_with(:ok)
        expect(last_response).to have_content_type(:json)
        expect(body).to be_json_eql serializer(rule)
      end
    end

    context "not found" do
      before { get "/api/policies/#{policy.uuid}/policy_rules/bogus-uuid" }

      it "does not return a record" do
        expect(last_response).to respond_with(:not_found)
        expect(last_response).to_not have_body
      end
    end
  end

  describe "POST /api/policies:policy_id/policy_rules" do
    let(:attributes) { attributes_for(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
    before { post "/api/policies/#{policy.uuid}/policy_rules", attributes.to_json }

    it "creates a record" do
      expect(last_response).to respond_with(:created)
      expect(last_response).to have_content_type(:json)
    end
  end

  describe "PATCH /api/policy_rules/:id" do
    context "valid" do
      let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      let(:attributes) { { escalation_timeout: 30 } }
      before { patch "/api/policy_rules/#{rule.uuid}", attributes.to_json }

      it "updates an existing record" do
        rule.reload
        expect(last_response).to respond_with(:no_content)
        expect(last_response).to_not have_body
        expect(rule.escalation_timeout).to eq 30
      end
    end

    context "not found" do
      before { patch "/api/policy_rules/bogus-uuid", {}.to_json }

      it "does not update a record" do
        expect(last_response).to respond_with(:not_found)
        expect(last_response).to_not have_body
      end
    end
  end

  describe "DELETE /api/policy_rules/:id" do
    context "valid" do
      let(:rule) { create(:policy_rule, policy: policy, assignment_attributes: assignment_attributes) }
      before { delete "/api/policy_rules/#{rule.uuid}" }

      it "deletes a record" do
        expect(last_response).to respond_with(:no_content)
        expect(last_response).to_not have_body
        expect(get "/api/policy_rules/#{rule.uuid}").to respond_with(:not_found)
      end
    end

    context "not found" do
      before { delete "/api/policy_rules/bogus-uuid" }

      it "does not delete a record" do
        expect(last_response).to respond_with(:not_found)
        expect(last_response).to_not have_body
      end
    end
  end

end
