require 'spec_helper'

describe Api::V1::IntegrationController do
  sign_in_service

  shared_context 'triggering an event' do
    let(:json_event) { JSON.parse(body) }
    let(:event) { service.events.last }

    it 'should create an event' do
      service.should have(1).event
    end

    it 'should return the right event attributes' do
      json_event['id'].should eq event.uuid
      json_event['state'].should eq event.state
      json_event['message'].should eq event.message
      json_event['description'].should eq event.description
      json_event['details'].should eq event.details
    end
  end

  describe 'PUT /api/trigger' do
    let(:attributes) { attributes_for(:event) }

    context 'without key' do
      before do
        put '/api/trigger', attributes.to_json
      end

      it { should respond_with(:created) }
      it { should have_content_type(:json) }

      include_context 'triggering an event'
    end

    context 'with key' do
      let(:attributes) { attributes_for(:event_with_key) }

      before do
        put '/api/trigger', attributes.to_json
      end

      it { should respond_with(:created) }
      it { should have_content_type(:json) }

      include_context 'triggering an event'

    end

    context 'with duplicate key' do
      let(:attributes) { attributes_for(:event_with_key) }
      let!(:existing_event) { create(:event_with_key, service: service) }

      before do
        put '/api/trigger', attributes.to_json
      end

      it { should respond_with(:accepted) }
      it { should have_content_type(:json) }
      
      include_context 'triggering an event'

    end

    context 'with duplicate key but different message' do
      let(:attributes) { attributes_for(:event_with_key) }

      before do
        create(:event_with_key, service: service, message: "Different message!")
        put '/api/trigger', attributes.to_json
      end

      include_context 'triggering an event'
    end

  end
end
