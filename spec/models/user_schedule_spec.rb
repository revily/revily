require 'spec_helper'

describe UserSchedule do
  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

  def now
    Time.zone.now
  end

  before { Timecop.freeze(Time.zone.local(2013, 10, 26)) }
  after { Timecop.return }

  describe '#initialize' do
    create_schedule(rule: 'daily', users_count: 2)
    let(:user_schedule) { UserSchedule.new(user_1, schedule_layer) }
    
    it 'builds a user schedule' do
      user_schedule.user.should equal user_1
      user_schedule.schedule_layer.should equal schedule_layer
      user_schedule.duration.should eq schedule_layer.duration
      user_schedule.start_time.should eq schedule_layer.start_at
    end
  end

  describe 'schedule rotation' do
    create_schedule(rule: 'daily', users_count: 2)

    describe 'for multiple users' do
      let(:user_1_schedule) { UserSchedule.new(user_1, schedule_layer) }
      let(:user_2_schedule) { UserSchedule.new(user_2, schedule_layer) }

      before { Timecop.freeze(Time.zone.now.beginning_of_day) }

      it 'sets a start_time' do
        user_1_schedule.start_time.should eq schedule_layer.start_at
      end

      it 'calculates the correct start date for each user' do
        user_1_schedule.should be_occurring_at schedule_layer.start_at
        user_1_schedule.should_not be_occurring_at 1.day.from_now
        user_1_schedule.should be_occurring_at 2.days.from_now
        user_2_schedule.should be_occurring_at 1.day.from_now
      end

      it 'still calculates the correct schedule after adding a user' do
        user_3 = create(:user)
        schedule_layer.users << user_3
        user_3_schedule = schedule_layer.user_schedule(user_3)

        user_1_schedule.should be_occurring_at now
        user_1_schedule.should be_occurring_at 3.days.from_now
        user_2_schedule.should be_occurring_at 1.day.from_now
        user_3_schedule.should be_occurring_at 2.days.from_now
      end
    end
  end
end
