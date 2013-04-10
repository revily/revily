require 'spec_helper'

describe SchedulesController do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }

  before do
    sign_in user
  end

  describe 'GET /schedules' do
    let(:schedule) { create(:schedule, account: account) }
    before { get :index }

    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe 'GET /schedules/:id' do
    let(:schedule) { create(:schedule, account: account) }
    before { get :show, id: schedule.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:show) }
  end

  describe 'GET /schedules/new' do
    before { get :new }

    it { should respond_with(:ok) }
    it { should render_template(:new) }
  end

  describe 'POST /schedules' do
    before { post :create, schedule: attributes_for(:schedule, account: account) }

    it { should respond_with(:found) }
    it { should redirect_to schedule_url(assigns(:schedule)) }
  end

  describe 'GET /schedules/:id/edit' do
    let(:schedule) { create(:schedule, account: account) }
    before { get 'edit', id: schedule.uuid }

    it { should respond_with(:ok) }
    it { should render_template(:edit) }
  end

  describe 'PUT /schedules/:id' do
    let(:schedule) { create(:schedule, account: account) }
    before { put :update, id: schedule.uuid, schedule: attributes_for(:schedule) }

    it { should respond_with(:found) }
    it { should redirect_to schedule_url(schedule) }
  end

  describe 'DELETE /schedules/:id' do
    let(:schedule) { create(:schedule, account: account) }
    before { delete :destroy, id: schedule.uuid }

    it { should respond_with(:found) }
    it { should redirect_to schedules_url }
  end

end
