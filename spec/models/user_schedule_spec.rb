require 'spec_helper'

describe UserSchedule do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:schedule) { create(:schedule) }
  let(:schedule_layer) { create(:daily_schedule_layer, schedule: schedule) }

  before do
    schedule_layer.users << user1
    schedule_layer.users << user2
    schedule_layer.should have(2).users
  end

  describe '#initialize' do
    let(:user_schedule) { UserSchedule.new(user1, schedule_layer) }

    it 'assigns the right instance variables' do
      user_schedule.user.should === user1
      user_schedule.schedule_layer.should === schedule_layer
      user_schedule.user_schedule_layer.user.should === user1
      user_schedule.user_schedule_layer.schedule_layer.should === schedule_layer
    end
  end

  describe '#build_schedule' do
    let(:user_schedule) { UserSchedule.new(user1, schedule_layer) }
    subject { user_schedule.schedule }

    it { should be_an_instance_of IceCube::Schedule }
    it 'builds a proper schedule' do
      user_schedule.schedule.duration.should eq user_schedule.duration
    end
    its(:duration) { should eq user_schedule.duration }
  end
end
