require 'spec_helper'

describe V1::IncidentsController do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  let(:service) { create(:service_with_escalation_policy, account: account) }

  before do
    sign_in user
  end

  describe 'GET /services/:service_id/incidents' do
    let!(:incident) { create(:incident, service: service) }
    before { get :index, service_id: service.uuid }

    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe 'GET /incidents/:id' do
    let(:incident) { create(:incident, service: service) }
    before { get :show, id: incident.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:show) }
  end

  describe 'GET /services/:service_id/incidents/new' do
    before { get :new, service_id: service.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:new) }
  end

  describe 'POST /services/:service_id/incidents' do
    before { post :create, service_id: service.uuid, incident: attributes_for(:incident) }

    it { should respond_with(:found) }
    it { should redirect_to incident_url(assigns(:incident)) }
  end

  describe 'GET /services/:service_id/incidents/:id/edit' do
    let(:incident) { create(:incident, service: service) }
    before { get 'edit', service_id: service.uuid, id: incident.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:edit) }
  end

  describe 'PUT /incidents/:id' do
    let(:incident) { create(:incident, service: service) }
    before { put :update, id: incident.uuid, incident: attributes_for(:incident) }

    it { should respond_with(:found) }
    it { should redirect_to incident_url(incident) }
  end

  describe 'DELETE /incidents/:id' do
    let(:incident) { create(:incident, service: service) }
    before { delete :destroy, id: incident.uuid }

    it { should respond_with(:found) }
    it { should redirect_to service_incidents_url(service) }
  end

end
