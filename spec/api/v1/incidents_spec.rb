require 'spec_helper'

describe "incidents" do
  sign_in_user

  let(:service) { create(:service, :with_policy, account: account) }

  describe 'GET /services/:service_id/incidents' do
    let(:incident) { create(:incident, service: service) }
    before { get "/services/#{service.uuid}/incidents" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
  end

  describe 'GET /incidents/:id' do
    let(:incident) { create(:incident, service: service) }
    before { get "/incidents/#{incident.uuid}" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
  end

  describe 'POST /services/:service_id/incidents' do
    before { post "/services/#{service.uuid}/incidents", attributes_for(:incident).to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  describe 'PUT /incidents/:id' do
    let(:incident) { create(:incident, service: service) }
    before { put "/incidents/#{incident.uuid}", attributes_for(:incident).to_json }

    it { should respond_with(:no_content) }
    it { should_not have_body }
     # have_content_type(:json) }
  end

  describe 'DELETE /incidents/:id' do
    let(:incident) { create(:incident, service: service) }
    before { delete "/incidents/#{incident.uuid}" }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

end
