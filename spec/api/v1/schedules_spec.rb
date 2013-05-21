require 'spec_helper'

describe 'schedules' do
  sign_in_user

  describe 'GET /schedules' do
    let(:schedule) { create(:schedule, account: account) }
    before { get "/schedules" }

    it { should respond_with(:ok) }
    # it { expect(body).to be_json_eql serializer([schedule]) }
  end

  describe 'GET /schedules/:id' do
    let(:schedule) { create(:schedule, account: account) }
    before { get "/schedules/#{schedule.uuid}" }

    it { should respond_with(:ok) }

  end

  describe 'POST /schedules' do
    before { post "/schedules", attributes_for(:schedule, account: account).to_json }

    it { should respond_with(:created) }
  end

  describe 'PUT /schedules/:id' do
    let(:schedule) { create(:schedule, account: account) }
    before { put "/schedules/#{schedule.uuid}", attributes_for(:schedule).to_json }

    it { should respond_with(:no_content) }
  end

  describe 'DELETE /schedules/:id' do
    let(:schedule) { create(:schedule, account: account) }
    before { delete "/schedules/#{schedule.uuid}" }

    it { should respond_with(:no_content) }
  end

end
