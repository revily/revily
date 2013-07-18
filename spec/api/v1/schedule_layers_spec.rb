require 'spec_helper'

describe 'schedule layers' do
  pause_events!
  sign_in_user

  let(:schedule) { create(:schedule, account: account) }

  describe 'GET /schedules/:schedule_id/layers' do
    let(:layer) { create(:schedule_layer, schedule: schedule) }
    before { get "/schedules/#{schedule.uuid}/layers" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
    # it { expect(body).to be_json_eql serializer([schedule]) }
  end

  describe 'GET /schedules/:schedule_id/layers/:id' do
    let(:layer) { create(:schedule_layer, schedule: schedule) }
    before { get "/schedules/#{schedule.uuid}/layers/#{layer.uuid}" }

    it { should respond_with(:ok) }
    it { should have_content_type(:json) }
  end

  describe 'POST /schedules/:schedule_id/layers' do
    before { post "/schedules/#{schedule.uuid}/layers", attributes_for(:schedule_layer).to_json }
    it { should respond_with(:created) }
    it { should have_content_type(:json) }
  end

  describe 'PUT /schedules/:schedule_id/layers/:id' do
    let(:layer) { create(:schedule_layer, schedule: schedule) }
    before { put "/schedules/#{schedule.uuid}/layers/#{layer.uuid}", attributes_for(:schedule_layer).to_json }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

  describe 'DELETE /schedules/:schedule_id/layers/:id' do
    let(:layer) { create(:schedule_layer, schedule: schedule) }
    before { delete "/schedules/#{schedule.uuid}/layers/#{layer.uuid}" }

    it { should respond_with(:no_content) }
    it { should_not have_body }
  end

end
