require 'spec_helper'

describe 'Events' do
  sign_in_user

  let(:service) { create(:service) }
  let(:event) { create(:event, service: service) }

  describe 'GET /events' do
    before { get "/services/#{service.id}/events" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    its(:body) { should be_json_eql Event.all.to_json }
  end

  describe 'GET /events/:id' do

  end

  describe 'POST /events' do

  end

  describe 'PUT /events/:id' do

  end

  describe 'DELETE /events/:id' do

  end
end