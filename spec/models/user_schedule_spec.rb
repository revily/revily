# require "unit_helper"
# require "active_support/core_ext/numeric/time"
# require "active_support/core_ext/numeric/conversions"

# require "models/user_schedule"

require "spec_helper"

describe UserSchedule do
  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

  freeze_time!

  describe "#initialize" do
    let(:schedule_layer) { double("ScheduleLayer") }
    let(:user) { double("User") }

    before do
      allow(schedule_layer).to receive(:user_position).with(user).and_return(1)
      allow(schedule_layer).to receive(:user_offset).with(user).and_return(0)
      allow(schedule_layer).to receive(:interval).and_return(1)
      allow(schedule_layer).to receive(:start_at).and_return(now.beginning_of_day)
      allow(schedule_layer).to receive(:duration).and_return(86400)
      allow(schedule_layer).to receive(:rule).and_return("daily")
    end

    let(:user_schedule) { UserSchedule.new(user, schedule_layer) }

    it "builds a user schedule" do
      expect(user_schedule.user).to equal user
      expect(user_schedule.schedule_layer).to equal schedule_layer
      expect(user_schedule.position).to eq schedule_layer.user_position(user)
      expect(user_schedule.offset).to eq schedule_layer.user_offset(user)
      expect(user_schedule.interval).to eq schedule_layer.interval
      expect(user_schedule.start_time).to eq schedule_layer.start_at
      expect(user_schedule.duration).to eq schedule_layer.duration
    end
  end

  describe "schedule rotation" do
    let(:schedule_layer) { double("ScheduleLayer") }
    let(:user_1) { double("User") }
    let(:user_2) { double("User") }

    let(:user_1_schedule) { UserSchedule.new(user_1, schedule_layer) }
    let(:user_2_schedule) { UserSchedule.new(user_2, schedule_layer) }

    before do
      allow(schedule_layer).to receive(:user_position).with(user_1).and_return(1)
      allow(schedule_layer).to receive(:user_position).with(user_2).and_return(2)
      allow(schedule_layer).to receive(:user_offset).with(user_1).and_return(0)
      allow(schedule_layer).to receive(:user_offset).with(user_2).and_return(86400)
      allow(schedule_layer).to receive(:interval).and_return(2)
      allow(schedule_layer).to receive(:start_at).and_return(now.beginning_of_day)
      allow(schedule_layer).to receive(:duration).and_return(86400)
      allow(schedule_layer).to receive(:rule).and_return("daily")
    end

    it "sets a start_time" do
      expect(user_1_schedule.start_time).to eq schedule_layer.start_at
      expect(user_2_schedule.start_time).to eq schedule_layer.start_at + 1.day
    end

    it "calculates the correct start date for each user" do
      expect(user_1_schedule).to be_occurring_at schedule_layer.start_at
      expect(user_1_schedule).to_not be_occurring_at 1.day.from_now
      expect(user_1_schedule).to be_occurring_at 2.days.from_now
      expect(user_2_schedule).to be_occurring_at 1.day.from_now
    end

  end
end
