require 'spec_helper'

describe Api::V1::ServicesController do
  sign_in_user

  let!(:service) { create(:service) }

  describe 'GET /api/services' do
    before { get '/api/services' }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }

    it { expect(body).to be_json_eql serializer([service]) }
  end

  describe 'GET /api/services/:id' do
    before { get "/api/services/#{service.to_param}" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(service) }
  end

  describe 'POST /api/services' do
    let(:escalation_policy) { create(:escalation_policy) }
    let(:attributes) { attributes_for(:service, :escalation_policy_id => escalation_policy.uuid) }
    before { post '/api/services', attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
    it { expect(body).to be_json_eql serializer(service) }
  end

  describe 'PUT /api/services/:id' do
    let(:attributes) { { name: "AWESOME APPLICATION" } }
    before { put "/api/services/#{service.to_param}", attributes.to_json }

    it { should respond_with(:ok) }
    it { expect(body).to be_json_eql serializer(service.reload) }
  end

  describe 'PUT /api/services/:id/enable' do
    before { put "/api/services/#{service.to_param}/enable" }

    it { should respond_with(:ok) }
    it { Service.find(service.id).should be_enabled }
    it { expect(body).to be_json_eql serializer(service) }
  end

  describe 'PUT /api/services/:id/disable' do
    before { put "/api/services/#{service.to_param}/disable" }

    it { should respond_with(:ok) }
    it { Service.find(service.id).should be_disabled }
    it { expect(body).to be_json_eql serializer(service.reload) }
  end

  describe 'DELETE /api/services/:id' do
    before { delete "/api/services/#{service.to_param}" }

    it { should respond_with(:no_content) }
    it 'should have zero services' do
      expect(Service.count).to be_zero
    end
  end
end
