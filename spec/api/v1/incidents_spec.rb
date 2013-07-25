require 'spec_helper'

describe "incidents" do
  pause_events!
  sign_in_user

  let(:service) { create(:service, :with_policy, account: account) }

  describe 'GET /services/:service_id/incidents' do
    let(:incident) { create(:incident, service: service) }
    before { get "/services/#{service.uuid}/incidents" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
  end

  describe 'GET /incidents/:id' do
    let(:incident) { create(:incident, service: service, account: account) }
    context 'valid' do
      before { get "/incidents/#{incident.uuid}" }

      it { should respond_with(:ok) }
      it { should have_content_type(:json) }
      it 'returns the correct record' do
        json['id'].should eq incident.uuid
        json['message'].should eq incident.message
      end
    end
  end

  describe 'POST /services/:service_id/incidents' do
    let(:attributes) { attributes_for(:incident) }
    before { post "/services/#{service.uuid}/incidents", attributes.to_json }

    it { should respond_with(:created) }
    it { should have_content_type(:json) }
    it 'creates with the right attributes' do
      incident = Incident.find_by(uuid: json['id'])
      incident.message.should eq attributes[:message]
      incident.service.should eq service
    end
  end

  describe 'PUT /incidents/:id' do
    let(:incident) { create(:incident, service: service, account: account) }
    let(:attributes) { attributes_for(:incident, message: "foo bar baz") }
    before { put "/incidents/#{incident.uuid}", attributes.to_json }

    it { should respond_with(:no_content) }
    it { should_not have_body }
    it 'updates with the right attributes' do
      incident.reload
      incident.message.should eq attributes[:message]
    end
  end

  describe 'DELETE /incidents/:id' do
    let(:incident) { create(:incident, service: service, account: account) }
    before { delete "/incidents/#{incident.uuid}" }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

end
