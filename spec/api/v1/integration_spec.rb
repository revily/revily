require 'spec_helper'

describe V1::IntegrationController do
  sign_in_service
  pause_events!

  shared_context 'created' do
    it { expect(subject).to respond_with(:created) }
    it { expect(subject).to have_content_type(:json) }
  end

  shared_context 'no_content' do
    it "responds with 204 No Content" do
      expect(subject).to respond_with(:no_content)
      expect(subject).to_not have_body
    end
  end

  shared_context 'not_modified' do
    it "responds with 304 Not Modified" do
      expect(subject).to respond_with(:not_modified)
      expect(subject).to_not have_body
    end
  end

  shared_context 'not_found' do
    it "responds with 404 Not Found" do
      expect(subject).to respond_with(:not_found)
      expect(subject).to_not have_body
    end
  end

  shared_context 'conflict' do
    it "responds with 409 Conflict" do
      expect(subject).to respond_with(:conflict)
      expect(subject).to have_body
    end
  end

  let(:message) { "foo bar" }
  let(:key) { "app.example.com/foo.bars" }

  describe 'PUT /trigger' do
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

      include_context 'not_modified'
    end

    context 'with existing message, without key' do
      before do
        create(:incident, message: message, service: service, account: account)
        put '/trigger', { message: message }.to_json
      end

      include_context 'not_modified'
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

      include_context 'not_modified'
    end

    context 'with no message' do
      before do
        put '/trigger', { }.to_json
      end

      it { should respond_with(:unprocessable_entity) }
      it {
        expect(json['errors']['message'][0]).to eq "can't be blank"
      }
    end
  end

  describe 'PUT /acknowledge' do
    context 'triggered incident using message' do
      before do
        create(:incident, message: message, key: key, service: service, account: account)
        put '/acknowledge', { message: message }.to_json
      end

      include_context 'no_content'
    end

    context 'triggered incident using key' do
      before do
        create(:incident, message: message, key: key, service: service, account: account)
        put '/acknowledge', { key: key }.to_json
      end

      include_context 'no_content'
    end

    context 'acknowledged incident using message' do
      let(:incident) { create(:incident, message: message, key: key, service: service, account: account) }

      before do
        incident.acknowledge
        put '/acknowledge', { message: message }.to_json
      end

      include_context 'no_content'
    end

    context 'acknowledged incident using key' do
      let(:incident) { create(:incident, message: message, key: key, service: service, account: account) }

      before do
        incident.acknowledge
        put '/acknowledge', { key: key }.to_json
      end

      include_context 'no_content'
    end

    context 'resolved incident using message' do
      let(:incident) { create(:incident, message: message, key: key, service: service, account: account) }

      before do
        incident.resolve
        put '/acknowledge', { message: message }.to_json
      end

      include_context 'not_found'
    end

    context 'resolved incident using key' do
      let(:incident) { create(:incident, message: message, key: key, service: service, account: account) }

      before do
        incident.resolve
        put '/acknowledge', { key: key }.to_json
      end

      include_context 'not_found'
    end

    context 'nonexistent incident using message' do
      before do
        put '/acknowledge', { message: "fake" }.to_json
      end

      include_context 'not_found'
    end

    context 'nonexistent incident using key' do
      before do
        put '/acknowledge', { key: "fake" }.to_json
      end

      include_context 'not_found'
    end

  end

  describe 'PUT /resolve' do

  end
end
