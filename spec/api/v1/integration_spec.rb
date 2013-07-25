require 'spec_helper'

describe V1::IntegrationController do
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

  shared_context 'created' do
    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  shared_context 'not modified' do
    it { should respond_with(:not_modified) }
    it { should_not have_body }
  end

  describe 'PUT /trigger' do
    let(:message) { "foo bar" }
    let(:key) { "app.example.com/foo.bars" }
    # let(:attributes) { attributes_for(:incident) }

    context 'with new message, without key' do
      before do
        put '/trigger', { message: message }.to_json
      end

      include_context 'created'
    end

    context 'with new message, with new key' do
      before do
        put '/trigger', { message: message, key: key }.to_json
      end

      include_context 'created'
    end

    context 'with new message, with existing key' do
      before do
        create(:incident, message: message, key: key, service: service, account: account)
        put '/trigger', { message: "new message", key: key }.to_json
      end

      include_context 'not modified'
    end

    context 'with existing message, without key' do
      before do
        create(:incident, message: message, service: service, account: account)
        put '/trigger', { message: message }.to_json
      end

      include_context 'not modified'
    end

    context 'with existing message, with new key' do
      before do
        create(:incident, message: message, key: key, service: service, account: account)
        put '/trigger', { message: message, key: "app2.example.com/foo.bars" }.to_json
      end

      include_context 'created'
    end

    context 'with existing message, with existing key' do
      before do
        create(:incident, message: message, key: key, service: service, account: account)
        put '/trigger', { message: message, key: key}.to_json
      end

      include_context 'not modified'
    end

    context 'with no message' do
      before do
        put '/trigger', { }.to_json
      end

      it { should respond_with(:unprocessable_entity) }
      it { 
        json['errors']['message'][0].should eq "can't be blank"
      }
    end

    # context 'without key' do
    #   before do
    #     ap attributes
    #     put '/trigger', attributes.to_json
    #   end

    #   it #{ should respond_with(:created) }
    #   it { should have_content_type(:json) }

    #   include_context 'triggering an incident'
    # end

    # context 'with key' do
    #   let(:attributes) { attributes_for(:incident_with_key) }

    #   before do
    #     put '/trigger', attributes.to_json
    #   end

    #   it #{ should respond_with(:created) }
    #   it { should have_content_type(:json) }

    #   include_context 'triggering an incident'

    # end

    # context 'with duplicate key' do
    #   let(:attributes) { attributes_for(:incident_with_key) }
    #   let!(:existing_incident) { create(:incident_with_key, service: service) }

    #   before do
    #     put '/trigger', attributes.to_json
    #   end

    #   it #{ should respond_with(:accepted) }
    #   it { should have_content_type(:json) }

    #   include_context 'triggering an incident'

    # end

    # context 'with duplicate key but different message' do
    #   let(:attributes) { attributes_for(:incident_with_key) }

    #   before do
    #     create(:incident_with_key, service: service, message: "Different message!")
    #     put '/trigger', attributes.to_json
    #   end

    #   include_context 'triggering an incident'
    # end

  end
end
