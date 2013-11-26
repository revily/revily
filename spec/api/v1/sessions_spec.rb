require "spec_helper"

describe "sessions" do
  pause_events!

  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  let(:credentials) { { email: user.email, password: user.password } }

  describe "POST create" do
    context "without credentials" do
      before { post "/api/sessions" }

      it 'returns HTTP 400' do
        expect(response).to respond_with(:unauthorized)
        expect(json["error"]).to eq "You are not authorized to perform this action."
      end
    end

    context "wrong credentials" do
      before { post "/api/sessions", { email: user.email, password: "" }.to_json }
      it "returns HTTP 401" do
        expect(response).to respond_with(:unauthorized)
        expect(json["error"]).to eq "You are not authorized to perform this action."
      end
    end

    context "correct email and password" do
      before { post "/api/sessions", credentials.to_json }

      it "returns HTTP 201" do
        expect(response).to respond_with(:created)
        expect(json).to include('id')
        expect(json).to include('authentication_token')
        expect(json["id"]).to eq user.uuid
        expect(json["authentication_token"]).to eq user.authentication_token
      end
    end
  end

  describe "DELETE destroy" do

  end
end
