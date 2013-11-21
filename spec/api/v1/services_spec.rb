require "spec_helper"

describe "services" do
  pause_events!
  sign_in_user

  describe "GET /api/services" do

    let!(:service) { create(:service, account: account) }
    before { get "/api/services" }

    it "returns a list of services" do
      expect(subject).to respond_with(:ok)
      expect(subject).to have_content_type(:json)
      # expect(body).to be_json_eql collection_serializer(account.services)
    end
  end

  describe "GET /services/:id" do
    let!(:service) { create(:service, account: account) }
    before { get "/api/services/#{service.to_param}" }

    it "returns a service" do
      expect(subject).to respond_with(:ok)
      expect(subject).to have_content_type(:json)
      expect(body).to be_json_eql serializer(service)
    end
  end

  describe "POST /api/services" do
    let(:policy) { create(:policy, account: account) }
    let(:attributes) { attributes_for(:service, :policy => policy) }
    before { post "/api/services", attributes.to_json }

    it "creates a service" do
      expect(subject).to respond_with(:created)
      expect(subject).to have_content_type(:json)
      expect(body).to be_json_eql serializer(Service.find_by(name: attributes[:name]))
    end
  end

  describe "PUT /api/services/:id" do
    let!(:service) { create(:service, account: account) }
    let(:attributes) { { name: "AWESOME APPLICATION" } }
    before { put "/api/services/#{service.to_param}", attributes.to_json }

    it "updates a service" do
      expect(subject).to respond_with(:no_content)
      expect(subject).to_not have_body
    end
  end

  describe "PUT /api/services/:id/enable" do
    let!(:service) { create(:service, account: account, state: "disabled") }
    before do
      put "/api/services/#{service.to_param}/enable"
      service.reload
    end

    it "enables a service" do
      expect(subject).to respond_with(:no_content)
      expect(Service.find(service.id)).to be_enabled
      expect(body).to be_json_eql ""
    end
  end

  describe "PUT /api/services/:id/disable" do
    let!(:service) { create(:service, account: account) }
    before do
      put "/api/services/#{service.to_param}/disable"
      service.reload
    end

    it "disables a service" do
      expect(subject).to respond_with(:no_content)
      expect(Service.find(service.id)).to be_disabled
      expect(subject).to_not have_body
    end
  end

  describe "DELETE /api/services/:id" do
    let!(:service) { create(:service, account: account) }
    before { delete "/api/services/#{service.to_param}" }

    it "deletes a service" do
      expect(subject).to respond_with(:no_content)
      expect(Service.count).to be_zero
    end
  end
end
