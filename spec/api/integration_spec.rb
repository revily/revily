require 'spec_helper'

describe 'Integration API' do
  let(:service) { create(:service) }
  let(:token) { service.authentication_token }
  let(:excluded_json_attributes) { ['details', 'description', 'id', 'service_id', 'uuid', 'triggered_at'] }

  before do
    header 'Authorization', %[Token token="#{token}"]
  end

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

  describe 'PUT /trigger' do
    let(:attributes) { attributes_for(:event) }

    context 'without key' do
      before do
        put '/trigger', attributes.to_json
      end

      it { should respond_with(:created) }
      it { should have_content_type(:json) }

      include_context 'triggering an event'
    end

    context 'with key' do
      let(:attributes) { attributes_for(:event_with_key) }

      before do
        put '/trigger', attributes.to_json
      end

      it { should respond_with(:created) }
      it { should have_content_type(:json) }

      include_context 'triggering an event'

    end

    context 'with duplicate key' do
      let(:attributes) { attributes_for(:event_with_key) }
      let!(:existing_event) { create(:event_with_key, service: service) }

      before do
        put '/trigger', attributes.to_json
      end

      it { should respond_with(:accepted) }
      it { should have_content_type(:json) }
      
      include_context 'triggering an event'

    end

    context 'with duplicate key but different message' do
      let(:attributes) { attributes_for(:event_with_key) }

      before do
        create(:event_with_key, service: service, message: "Different message!")
        put '/trigger', attributes.to_json
      end

      include_context 'triggering an event'
    end

  end
end
