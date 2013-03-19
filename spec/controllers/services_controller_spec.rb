require 'spec_helper'

describe ServicesController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /services' do
    let!(:service) { create(:service) }
    before { get :index }

    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should assign_to(:services).with([service]) }
  end

  describe 'GET /services/:id' do
    let!(:service) { create(:service) }
    before { get :show, id: service.id }

    it { should respond_with(:ok) }
    it { should render_template(:show) }
    it { should assign_to(:service).with(service) }
  end

  describe 'GET /services/new' do
    before { get :new }

    it { should respond_with(:ok) }
    it { should render_template(:new) }
    it { should assign_to(:service) }
  end

  describe 'POST /services' do
    before { post :create, service: attributes_for(:service) }

    it { should respond_with(:found) }
    it { should redirect_to service_url(assigns(:service)) }
  end

  describe 'GET /services/:id/edit' do
    let!(:service) { create(:service) }
    before { get 'edit', id: service.id }

    it { should respond_with(:ok) }
    it { should render_template(:edit) }
    it { should assign_to(:service).with(service) }
  end

  describe 'PUT /services/:id' do
    let(:service) { create(:service) }
    before { put :update, id: service.id, service: attributes_for(:service) }

    it { should respond_with(:found) }
    it { should redirect_to service_url(service) }
    it { should assign_to(:service).with(service) }
  end

  describe 'DELETE /services/:id' do
    let(:service) { create(:service) }
    before { delete :destroy, id: service.id, id: service.id }

    it { should respond_with(:found) }
    it { should redirect_to services_url }
    it { should assign_to(:service).with(service) }

  end

end
