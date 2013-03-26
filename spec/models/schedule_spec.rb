require 'spec_helper'

describe Schedule do
  describe 'associations' do
    it { should have_many(:schedule_layers) }
    it { should have_many(:user_schedule_layers).through(:schedule_layers) }
    it { should have_many(:users).through(:user_schedule_layers) }
    it { should have_many(:escalation_rules) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:time_zone) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:uuid) }
  end

  describe '#current_user_on_call' do
    let(:schedule) { create(:schedule_with_layers_and_users) }
    let(:schedule_layer) { schedule.schedule_layers.first }
    let(:user_1) { schedule_layer.users.first }
    let(:user_2) { schedule_layer.users.second }

    before { Timecop.freeze(Time.zone.now.beginning_of_day) }
    after { Timecop.return }

    it 'retrieves the current user on call' do
      schedule.current_user_on_call.should eq user_1
      Timecop.travel(1.day) && Timecop.freeze
      schedule.current_user_on_call.should eq user_2
      Timecop.travel(1.day) && Timecop.freeze
      schedule.current_user_on_call.should eq user_1
    end

  end
end
