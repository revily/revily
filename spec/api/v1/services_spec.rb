require 'spec_helper'

describe "services" do
  pause_events!
  sign_in_user

  describe 'GET /services' do

    let!(:service) { create(:service, account: account) }
    before { get '/services' }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer([service]) }
  end

  describe 'GET /services/:id' do
    let!(:service) { create(:service, account: account) }
    before { get "/services/#{service.to_param}" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(service) }
  end

  describe 'POST /services' do
    let(:policy) { create(:policy, account: account) }
    let(:attributes) { attributes_for(:service, :policy_id => policy.uuid) }
    before { post '/services', attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(Service.find_by_name(attributes[:name])) }
  end

  describe 'PUT /services/:id' do
    let!(:service) { create(:service, account: account) }
    let(:attributes) { { name: "AWESOME APPLICATION" } }
    before { put "/services/#{service.to_param}", attributes.to_json }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

  describe 'PUT /services/:id/enable' do
    let!(:service) { create(:service, account: account, state: 'disabled') }
    before do
      put "/services/#{service.to_param}/enable"
      service.reload
    end

    it { should respond_with(:no_content) }
    it { Service.find(service.id).should be_enabled }
    it { expect(body).to be_json_eql "" }
  end

  describe 'PUT /services/:id/disable' do
    let!(:service) { create(:service, account: account) }
    before do
      put "/services/#{service.to_param}/disable"
      service.reload
    end

    it { should respond_with(:no_content) }
    it { Service.find(service.id).should be_disabled }
    it { should_not have_body }
  end

  describe 'DELETE /services/:id' do
    let!(:service) { create(:service, account: account) }
    before { delete "/services/#{service.to_param}" }

    it { should respond_with(:no_content) }
    it 'should have zero services' do
      expect(Service.count).to be_zero
    end
  end
end
