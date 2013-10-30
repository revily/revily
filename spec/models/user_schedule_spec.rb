require 'spec_helper'

describe UserSchedule do
  pause_events!

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
      expect(user_schedule.user).to equal user_1
      expect(user_schedule.schedule_layer).to equal schedule_layer
      expect(user_schedule.duration).to eq schedule_layer.duration
      expect(user_schedule.start_time).to eq schedule_layer.start_at
    end
  end

  describe 'schedule rotation' do
    create_schedule(rule: 'daily', users_count: 2)

    describe 'for multiple users' do
      let(:user_1_schedule) { UserSchedule.new(user_1, schedule_layer) }
      let(:user_2_schedule) { UserSchedule.new(user_2, schedule_layer) }

      before { Timecop.freeze(Time.zone.now.beginning_of_day) }

      it 'sets a start_time' do
        expect(user_1_schedule.start_time).to eq schedule_layer.start_at
      end

      it 'calculates the correct start date for each user' do
        expect(user_1_schedule).to be_occurring_at schedule_layer.start_at
        expect(user_1_schedule).to_not be_occurring_at 1.day.from_now
        expect(user_1_schedule).to be_occurring_at 2.days.from_now
        expect(user_2_schedule).to be_occurring_at 1.day.from_now
      end

      it 'still calculates the correct schedule after adding a user' do
        user_3 = create(:user)
        schedule_layer.users << user_3
        user_3_schedule = schedule_layer.user_schedule(user_3)

        expect(user_1_schedule).to be_occurring_at now
        expect(user_1_schedule).to be_occurring_at 3.days.from_now
        expect(user_2_schedule).to be_occurring_at 1.day.from_now
        expect(user_3_schedule).to be_occurring_at 2.days.from_now
      end
    end
  end
end
