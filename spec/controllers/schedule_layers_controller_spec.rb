require 'spec_helper'

describe ScheduleLayersController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /schedules/:schedule_id/layers' do
    let(:schedule) { create(:schedule) }
    let!(:layer) { create(:schedule_layer, schedule: schedule) }
    before { get :index, schedule_id: schedule.id }

    it { should assign_to(:schedule_layers).with([layer]) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe 'GET /layers/:id' do
    let(:schedule) { create(:schedule) }
    let(:layer) { create(:schedule_layer) }
    before { get :show, schedule_id: schedule.uuid, id: layer.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:show) }
  end

  describe 'GET /schedules/:schedule_id/layers/new' do
    let(:schedule) { create(:schedule) }
    before { get :new, schedule_id: schedule.id }

    it { should respond_with(:ok) }
    it { should render_template(:new) }
  end

  describe 'POST /schedules/:schedule_id/layers' do
    let(:schedule) { create(:schedule) }
    before { post :create, schedule_id: schedule.uuid, layer: attributes_for(:schedule_layer) }

    it { should respond_with(:found) }
    it { should redirect_to schedule_schedule_layer_url(schedule, assigns(:schedule_layer)) }
  end

  describe 'GET /schedules/:schedule_id/layers/:id/edit' do
    let(:schedule) { create(:schedule) }
    let(:layer) { create(:schedule_layer) }
    before { get 'edit', schedule_id: schedule.uuid, id: layer.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:edit) }
  end

  describe 'PUT /layers/:id' do
    let(:schedule) { create(:schedule) }
    let(:layer) { create(:schedule_layer, schedule: schedule) }
    before { put :update, schedule_id: schedule.uuid, id: layer.uuid, layer: attributes_for(:schedule_layer) }

    it { should respond_with(:found) }
    it { should redirect_to schedule_schedule_layer_url(layer) }
    it { should assign_to(:schedule_layer) }
  end

  describe 'DELETE /layers/:id' do
    let(:schedule) { create(:schedule) }
    let(:layer) { create(:schedule_layer, schedule: schedule) }
    before { delete :destroy, schedule_id: schedule.uuid, id: layer.uuid }

    it { should respond_with(:found) }
    it { should redirect_to schedule_schedule_layers_url(schedule) }
  end

end
