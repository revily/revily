require 'spec_helper'

describe ServicesController do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }

  before do
    sign_in user
  end

  describe 'GET /services' do
    let(:service) { create(:service, account: account) }
    before { get :index }

    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should assign_to(:services).with([service]) }
  end

  describe 'GET /services/:id' do
    let(:service) { create(:service, account: account) }
    before { get :show, id: service.uuid }

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
    before { post :create, service: attributes_for(:service, account: account) }

    it { should respond_with(:found) }
    it { should redirect_to service_url(assigns(:service)) }
  end

  describe 'GET /services/:id/edit' do
    let(:service) { create(:service, account: account) }
    before { get 'edit', id: service.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:edit) }
    it { should assign_to(:service).with(service.decorate) }
  end

  describe 'PUT /services/:id' do
    let(:service) { create(:service, account: account) }
    before { put :update, id: service.uuid, service: attributes_for(:service, account: account) }

    it { should respond_with(:found) }
    it { should redirect_to service_url(service) }
    it { should assign_to(:service).with(service) }
  end

  describe 'DELETE /services/:id' do
    let(:service) { create(:service, account: account) }
    before { delete :destroy, id: service.uuid }

    it { should respond_with(:found) }
    it { should redirect_to services_url }
    it { should assign_to(:service).with(service) }
  end

end
