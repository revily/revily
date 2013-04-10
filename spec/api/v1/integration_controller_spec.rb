require 'spec_helper'

describe Api::V1::IntegrationController do
  sign_in_service

  shared_context 'triggering an incident' do
    let(:json_incident) { JSON.parse(body) }
    let(:incident) { service.incidents.last }

    it 'should create an incident' do
      service.should have(1).incident
    end

    it 'should return the right incident attributes' do
      json_incident['id'].should eq incident.uuid
      json_incident['state'].should eq incident.state
      json_incident['message'].should eq incident.message
      json_incident['description'].should eq incident.description
      json_incident['details'].should eq incident.details
    end
  end

  describe 'PUT /api/trigger' do
    let(:attributes) { attributes_for(:incident) }

    context 'without key' do
      before do
        put '/api/trigger', attributes.to_json
      end

      it #{ should respond_with(:created) }
      it { should have_content_type(:json) }

      include_context 'triggering an incident'
    end

    context 'with key' do
      let(:attributes) { attributes_for(:incident_with_key) }

      before do
        put '/api/trigger', attributes.to_json
      end

      it #{ should respond_with(:created) }
      it { should have_content_type(:json) }

      include_context 'triggering an incident'

    end

    context 'with duplicate key' do
      let(:attributes) { attributes_for(:incident_with_key) }
      let!(:existing_incident) { create(:incident_with_key, service: service) }

      before do
        put '/api/trigger', attributes.to_json
      end

      it #{ should respond_with(:accepted) }
      it { should have_content_type(:json) }
      
      include_context 'triggering an incident'

    end

    context 'with duplicate key but different message' do
      let(:attributes) { attributes_for(:incident_with_key) }

      before do
        create(:incident_with_key, service: service, message: "Different message!")
        put '/api/trigger', attributes.to_json
      end

      include_context 'triggering an incident'
    end

  end
end
