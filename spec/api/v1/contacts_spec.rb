require 'spec_helper'

describe 'contacts' do
  pause_events!
  sign_in_user
  
  let(:user) { create(:user, account: account) }

  describe 'GET /users/:user_id/contacts' do
    context 'valid' do
      let(:contact) { create(:email_contact, user: user) }
      before { user.reload; get "/users/#{user.uuid}/contacts" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it { expect(body['_embedded']).to have_json_size(1) }
      # it { expect(body).to be_json_eql collection_serializer(user.contacts) }
    end

    context 'none' do
      before { get "/users/#{user.uuid}/contacts" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it { expect(body).to have_json_size(0) }
      it { expect(body).to be_json_eql([]) }
    end
  end

  describe 'GET /users/:user_id/contacts/:id' do
    context 'valid' do
      let(:contact) { create(:email_contact, user: user) }
      before { get "/users/#{user.uuid}/contacts/#{contact.uuid}" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it { expect(body).to be_json_eql serializer(contact) }
    end

    context 'not found' do
      before { get "/users/#{user.uuid}/contacts/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body }
    end
  end

  describe 'POST /users/:user_id/contacts' do
    let(:attributes) { attributes_for(:email_contact).merge(:type => "email") }
    before { post "/users/#{user.uuid}/contacts", attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  describe 'PATCH /users/:user_id/contacts/:id' do
    context 'valid' do
      let(:contact) { create(:email_contact, user: user) }
      let(:attributes) { { label: "foo" } }
      before { patch "/users/#{user.uuid}/contacts/#{contact.uuid}", attributes.to_json }

      it { should respond_with(:no_content) }
      it { should_not have_body }
      it { expect(contact.reload.label).to eq "foo" }
    end

    context 'not found' do
      before { patch "/users/#{user.uuid}/contacts/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body }
    end
  end

  describe 'DELETE /users/:user_id/contacts/:id' do

    context 'valid' do
      let(:contact) { create(:email_contact, user: user) }
      before { delete "/users/#{user.uuid}/contacts/#{contact.uuid}" }

      it { should respond_with(:no_content) }
      it { should_not have_body }
    end

    context 'not found' do
      before { delete "/users/#{user.uuid}/contacts/bogus-uuid" }

      it { should respond_with(:not_found) }
      it { should_not have_body}
    end
  end

end
 