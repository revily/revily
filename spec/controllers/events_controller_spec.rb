require 'spec_helper'

describe EventsController do
  let(:user) { create(:user) }
  let(:service) { create(:service) }

  before do
    sign_in user
  end

  describe 'GET /services/:service_id/events' do
    let!(:event) { create(:event, service: service) }
    before { get :index, service_id: service.id }

    it { should assign_to(:events).with([event]) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe 'GET /services/:service_id/events/:id' do
    let!(:event) { create(:event) }
    before { get :show, service_id: service.id, id: event.id }

    it { should respond_with(:ok) }
    it { should render_template(:show) }
  end

  describe 'GET /services/:service_id/events/new' do
    before { get :new, service_id: service.id }

    it { should respond_with(:ok) }
    it { should render_template(:new) }
  end

  describe 'POST /services/:service_id/events' do
    before { post :create, service_id: service.id, event: attributes_for(:event) }

    it { should respond_with(:found) }
    it { should redirect_to service_event_url(service, assigns(:event)) }
  end

  describe 'GET /services/:service_id/events/:id/edit' do
    let!(:event) { create(:event) }
    before { get 'edit', service_id: service.id, id: event.id }

    it { should respond_with(:ok) }
    it { should render_template(:edit) }
  end

  describe 'PUT /services/:service_id/events/:id' do
    let(:event) { create(:event, service: service) }
    before { put :update, service_id: service.id, id: event.id, event: attributes_for(:event) }

    it { should respond_with(:found) }
    it { should redirect_to service_event_url(service, event) }
    it { should assign_to(:event) }
  end

  describe 'DELETE /services/:service_id/events/:id' do
    let(:event) { create(:event, service: service) }
    before { delete :destroy, service_id: service.id, id: event.id }

    it { should respond_with(:found) }
    it { should redirect_to service_events_url(service) }
  end

end
