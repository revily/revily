require 'spec_helper'

describe UserSchedule do

  def now
    Time.zone.now
  end

  before { Timecop.freeze(Time.zone.local(2013, 10, 26)) }
  after { Timecop.return }
  
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user_3) { create(:user) } # not adding this user to the schedule_layer just yet

  let(:schedule) { create(:schedule) }
  let(:schedule_layer) { create(:daily_schedule_layer, schedule: schedule) }
  
  before do
    schedule_layer.users << user_1
    schedule_layer.users << user_2
    schedule_layer.should have(2).users
  end

  describe '#initialize' do
    let(:user_schedule) { UserSchedule.new(user_1, schedule_layer) }

    it 'builds a user schedule' do
      user_schedule.user.should equal user_1
      user_schedule.schedule_layer.should equal schedule_layer
      user_schedule.duration.should eq schedule_layer.duration
      user_schedule.start_time.should eq schedule_layer.start_at
    end
  end

  describe 'schedule rotation' do

    let(:schedule) { create(:schedule) }
    let(:schedule_layer) { create(:daily_schedule_layer, schedule: schedule) }


    describe 'for multiple users' do
      let(:user_1_schedule) { UserSchedule.new(user_1, schedule_layer) }
      let(:user_2_schedule) { UserSchedule.new(user_2, schedule_layer) }

      before { Timecop.freeze(Time.zone.now.beginning_of_day) }

      it 'sets a start_time' do
        user_1_schedule.start_time.should eq schedule_layer.start_at
      end

      it 'calculates the correct start date for each user' do
        user_1_schedule.first.should eq schedule_layer.start_at
        user_1_schedule.next_occurrence.should_not eq (schedule_layer.start_at + 1.day)
        user_1_schedule.next_occurrence.should eq schedule_layer.start_at + 2.days

        user_2_schedule.first.should eq (schedule_layer.start_at + 1.day)
      end

      it 'still calculates the correct schedule after adding a user' do

        schedule_layer.users << user_3
        user_3_schedule = schedule_layer.user_schedule(user_3)

        user_1_schedule.first.should eq schedule_layer.start_at
        user_1_schedule.should be_occurring_at now
        user_1_schedule.next_occurrence.should eq now + 3.days
        Timecop.travel(1.day) && Timecop.freeze
        user_2_schedule.should be_occurring_at now
        user_3_schedule.should be_occurring_at now + 1.day
      end
    end
  end
end
