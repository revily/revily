require "spec_helper"

describe "users" do
  pause_events!
  sign_in_user

  describe "GET /api/users" do

    let!(:user) { create(:user, account: account) }
    before { get "/api/users" }

    it "returns a list of users" do
      expect(last_response).to respond_with(:ok)
      expect(last_response).to have_content_type(:json)
      expect(body).to be_json_eql collection_serializer(account.users)
    end
  end

  describe "GET /api/users/:id" do
    let!(:user) { create(:user, account: account) }
    before { get "/api/users/#{user.to_param}" }

    it "returns a user" do
      expect(last_response).to respond_with(:ok)
      expect(last_response).to have_content_type(:json)
      expect(body).to be_json_eql serializer(user)
    end
  end

  describe "POST /api/users" do
    let(:attributes) { attributes_for(:user) }
    before { post "/api/users", attributes.to_json }
    let!(:new_user) { User.find_by(name: attributes[:name]) }

    it "creates a user" do
      expect(last_response).to respond_with :created
      expect(last_response).to have_content_type :json
      expect(body).to be_json_eql serializer(new_user)
      expect(new_user.name).to eq attributes[:name]
      expect(new_user.email).to eq attributes[:email]
      expect(new_user.authentication_token).to_not be_nil
    end
  end

  describe "PUT /api/users/:id" do
    let(:new_user) { create(:user, account: account) }
    let(:attributes) { { name: "Bill Williamson" } }
    before { put "/api/users/#{new_user.to_param}", attributes.to_json }

    it "updates a user" do
      new_user.reload
      expect(last_response).to respond_with(:no_content)
      expect(last_response).to_not have_body
      expect(new_user.name).to eq "Bill Williamson"
    end

  end

  describe "DELETE /api/users/:id" do
    let(:user) { create(:user, account: account) }
    before { delete "/api/users/#{user.to_param}" }

    it "deletes a user" do
      user = User.find_by(name: user)
      expect(last_response).to respond_with :no_content
      expect(user).to be_nil
    end
  end
end
