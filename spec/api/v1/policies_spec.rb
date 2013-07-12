require 'spec_helper'

describe 'policies' do
  sign_in_user

  describe 'GET /policies' do
    let!(:policy) { create(:policy, account: account) }
    before { get "/policies" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer([policy]) }
  end

  describe 'GET /policies/:id' do
    let!(:policy) { create(:policy, account: account) }
    before { get "/policies/#{policy.uuid}" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(policy) }
  end

  describe 'POST /policies' do
    let(:attributes) { attributes_for(:policy, account: account) }
    before { post "/policies", attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(build_stubbed(:policy, attributes)) }
  end

  describe 'PUT /policies/:id' do
    let(:policy) { create(:policy, account: account) }
    before { put "/policies/#{policy.uuid}", attributes_for(:policy).to_json }

    it { should respond_with(:no_content) }
    it { should_not have_body }

  end

  describe 'DELETE /policies/:id' do
    let(:policy) { create(:policy, account: account) }
    before { delete "/policies/#{policy.uuid}" }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

end
