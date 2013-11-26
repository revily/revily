# require "spec_helper"

# describe V1::SessionsController do
#   pause_events!
  
#   let(:account) { create(:account) }
#   let(:user) { create(:user, account: account) }

#   describe "POST create" do
#     context "without token" do
#       before { post :create }

#       it 'returns HTTP 400' do
#         expect(response).to respond_with(:bad_request)
#       end
#     end

#     context "wrong credentials" do
#       before { post :create, email: user.email, password: "" }
#       it "returns HTTP 401" do
#         expect(response).to respond_with(:unauthorized)
#       end
#     end

#     context "correct email and password" do
#       before { post :create, { email: user.email, password: user.password }.to_json }
#       subject(:body) { JSON.parse response.body }
#       it "returns HTTP 201" do
#         expect(response).to respond_with(:created)
#         expect(body).to include('user_id')
#         expect(body).to include('authentication_token')
#       end
#     end
#   end

#   describe "DELETE destroy" do

#   end
# end
