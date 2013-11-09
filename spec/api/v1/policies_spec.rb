require "spec_helper"

describe "policies" do
  pause_events!
  sign_in_user

  describe "GET /api/policies" do
    let!(:policy) { create(:policy, account: account) }
    before { get "/api/policies" }

    it "returns a list of policies" do
      expect(subject).to respond_with(:ok)
      expect(subject).to have_content_type(:json)
      expect(body).to be_json_eql collection_serializer(account.policies)
    end
  end

  describe "GET /api/policies/:id" do
    let!(:policy) { create(:policy, account: account) }
    before { get "/api/policies/#{policy.uuid}" }

    it "returns a list of policies" do
      expect(subject).to respond_with(:ok)
      expect(subject).to have_content_type(:json)
      expect(body).to be_json_eql serializer(policy)
    end
  end

  describe "POST /api/policies" do
    let(:attributes) { attributes_for(:policy, account: account) }
    before { post "/api/policies", attributes.to_json }

    it "creates a policy" do
      expect(subject).to respond_with(:created)
      expect(subject).to have_content_type(:json)
      expect(body).to be_json_eql serializer(build_stubbed(:policy, attributes))
    end
  end

  describe "PUT /api/policies/:id" do
    let(:policy) { create(:policy, account: account) }
    before { put "/api/policies/#{policy.uuid}", attributes_for(:policy).to_json }

    it "updates a policy" do
      expect(subject).to respond_with(:no_content)
      expect(subject).to_not have_body
    end
  end

  describe "DELETE /api/policies/:id" do
    let(:policy) { create(:policy, account: account) }
    before { delete "/api/policies/#{policy.uuid}" }

    it "deletes a policy" do
      expect(subject).to respond_with(:no_content)
      expect(subject).to_not have_body
    end
  end

end
