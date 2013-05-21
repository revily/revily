require 'spec_helper'

describe V1::ScheduleLayersController do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  before do
    sign_in user
  end

  shared_examples_for 'a correctly scoped schedule' do
    let(:other_account) { create(:account) }
    it 'scopes to the right account' do
      schedule.account.should == account
    end

    it 'does not scope to a different account' do
      schedule.account.should_not == other_account
    end
  end

  describe 'GET /schedules/:schedule_id/layers' do
    let(:schedule) { create(:schedule, account: account) }
    let!(:layer) { create(:schedule_layer, schedule: schedule) }
    before { get :index, schedule_id: schedule.id }

    it { should respond_with(:success) }

    it_behaves_like 'a correctly scoped schedule'
  end

  describe 'GET /layers/:id' do
    let(:schedule) { create(:schedule, account: account) }
    let(:layer) { create(:schedule_layer) }
    before { get :show, schedule_id: schedule.uuid, id: layer.uuid }

    it { should respond_with(:ok) }

    it_behaves_like 'a correctly scoped schedule'
  end

  describe 'GET /schedules/:schedule_id/layers/new' do
    let(:schedule) { create(:schedule, account: account) }
    before { get :new, schedule_id: schedule.uuid }

    it { should respond_with(:ok) }

    it_behaves_like 'a correctly scoped schedule'
  end

  describe 'POST /schedules/:schedule_id/layers' do
    let(:schedule) { create(:schedule, account: account) }
    before { post :create, schedule_id: schedule.uuid, schedule_layer: attributes_for(:schedule_layer) }

    it { should respond_with(:found) }
    it { should redirect_to schedule_schedule_layer_url(schedule, assigns(:schedule_layer)) }
    it_behaves_like 'a correctly scoped schedule'
  end

  describe 'GET /schedules/:schedule_id/layers/:id/edit' do
    let(:schedule) { create(:schedule, account: account) }
    let(:layer) { create(:schedule_layer) }
    before { get 'edit', schedule_id: schedule.uuid, id: layer.uuid }

    it { should respond_with(:ok) }

    it_behaves_like 'a correctly scoped schedule'
  end

  describe 'PUT /schedules/:schedule_id/layers/:id' do
    let(:schedule) { create(:schedule, account: account) }
    let(:schedule_layer) { create(:schedule_layer, schedule: schedule) }
    before { put :update, schedule_id: schedule.uuid, id: schedule_layer.uuid, schedule_layer: attributes_for(:schedule_layer) }

    it { should respond_with(:found) }
    it { should redirect_to schedule_schedule_layer_url(schedule, schedule_layer) }
    it_behaves_like 'a correctly scoped schedule'
  end

  describe 'DELETE /layers/:id' do
    let(:schedule) { create(:schedule, account: account) }
    let(:schedule_layer) { create(:schedule_layer, schedule: schedule) }
    before { delete :destroy, schedule_id: schedule.uuid, id: schedule_layer.uuid }

    it { should respond_with(:found) }
    it { should redirect_to schedule_schedule_layers_url(schedule) }
    it_behaves_like 'a correctly scoped schedule'
  end

end
