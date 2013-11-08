require "spec_helper"

describe "Contacts Requests" do
  pause_events!
  sign_in_user
  
  let(:user) { create(:user, account: account) }

  describe "GET /api/users/{user_id}/contacts" do
    let!(:contact) { create(:email_contact, user: user) }
    before { get api_user_contacts_path(user) }

    it "responds with the requested contact" do
      expect(status).to respond_with(:ok)
    end
  end

  describe "GET /api/users/:user_id/contacts/:id" do
    context "valid" do
      let(:contact) { create(:email_contact, user: user) }
      before { get "/api/users/#{user.uuid}/contacts/#{contact.uuid}" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it { expect(body).to be_json_eql serializer(contact) }
    end

    context "not found" do
      before { get "/api/users/#{user.uuid}/contacts/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body }
    end
  end

  describe "POST /api/users/:user_id/contacts" do
    let(:attributes) { attributes_for(:email_contact, :type => "email") }
    before { post "/api/users/#{user.uuid}/contacts", attributes.to_json }
    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  describe "PATCH /users/:user_id/contacts/:id" do
    context "valid" do
      let(:contact) { create(:email_contact, user: user) }
      let(:attributes) { { label: "foo" } }
      before { patch "/api/users/#{user.uuid}/contacts/#{contact.uuid}", attributes.to_json }

      it { should respond_with(:no_content) }
      it { should_not have_body }
      it { expect(contact.reload.label).to eq "foo" }
    end

    context "not found" do
      before { patch "/api/users/#{user.uuid}/contacts/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body }
    end
  end

  describe "DELETE /api/users/:user_id/contacts/:id" do

    context "valid" do
      let(:contact) { create(:email_contact, user: user) }
      before { delete "/api/users/#{user.uuid}/contacts/#{contact.uuid}" }

      it { should respond_with(:no_content) }
      it { should_not have_body }
    end

    context "not found" do
      before { delete "/api/users/#{user.uuid}/contacts/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body}
    end
  end

end
 
