require 'spec_helper'

describe "incidents" do
  pause_events!
  sign_in_user

  let(:service) { create(:service, :with_policy, account: account) }

  describe 'GET /services/:service_id/incidents' do
    let(:incident) { create(:incident, service: service) }
    before { get "/services/#{service.uuid}/incidents" }

    it 'returns all incidents for a service' do
      expect(last_response).to respond_with :ok
      expect(last_response).to have_content_type :json
    end
  end

  describe 'GET /incidents/:id' do
    let(:incident) { create(:incident, service: service, account: account) }
    context 'valid' do
      before { get "/incidents/#{incident.uuid}" }

      it 'returns the correct record' do
        expect(last_response).to have_content_type :json
        expect(last_response).to respond_with :ok
        expect(json['id']).to eq incident.uuid
        expect(json['message']).to eq incident.message
      end
    end
  end

  describe 'POST /services/:service_id/incidents' do
    let(:attributes) { attributes_for(:incident) }
    before { post "/services/#{service.uuid}/incidents", attributes.to_json }

    it 'creates with the right attributes' do
      incident = Incident.find_by(uuid: json['id'])

      expect(last_response).to have_content_type :json
      expect(last_response).to respond_with :created
      expect(incident.message).to eq attributes[:message]
      expect(incident.service).to eq service
    end
  end

  describe 'PUT /incidents/:id' do
    let(:incident) { create(:incident, service: service, account: account) }
    let(:attributes) { attributes_for(:incident, message: "foo bar baz") }
    before { put "/incidents/#{incident.uuid}", attributes.to_json }

    it 'updates with the right attributes' do
      incident.reload

      expect(last_response).to_not have_body
      expect(last_response).to respond_with :no_content
      expect(incident.message).to eq attributes[:message]
    end
  end

  describe 'DELETE /incidents/:id' do
    let(:incident) { create(:incident, service: service, account: account) }
    before { delete "/incidents/#{incident.uuid}" }

    it 'deletes the service' do
      expect(last_response).to_not have_body
      expect(last_response).to respond_with :no_content
    end
  end

end
