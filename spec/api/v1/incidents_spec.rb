require 'spec_helper'

describe 'Incidents' do
  sign_in_user

  let(:service) { create(:service) }
  let(:incident) { create(:incident, service: service) }

  describe 'GET /incidents' do
    before { get "/services/#{service.id}/incidents" }

    # it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    its(:body) { should be_json_eql Incident.all.to_json }
  end

  describe 'GET /incidents/:id' do

  end

  describe 'POST /incidents' do

  end

  describe 'PUT /incidents/:id' do

  end

  describe 'DELETE /incidents/:id' do

  end
end