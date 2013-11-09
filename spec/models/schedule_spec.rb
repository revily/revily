require "spec_helper"

describe Schedule do
  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

  pause_events!
  freeze_time!

  it "associations" do
    expect(subject).to belong_to(:account)
    expect(subject).to have_many(:schedule_layers)
    expect(subject).to have_many(:user_schedule_layers).through(:schedule_layers)
    expect(subject).to have_many(:users).through(:user_schedule_layers)
    expect(subject).to have_many(:policy_rules)
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:time_zone) }
  end

  context "attributes" do
    it { should have_readonly_attribute(:uuid) }
    it "uses uuid for #to_param" do
      obj = create(subject.class)
      expect(obj.to_param).to eq obj.uuid
    end
  end

  describe "#current_user_on_call" do
    context "daily rotation" do
      create_schedule(rule: "daily", users_count: 2)

      it "works with multiple users" do
        expect(schedule.current_user_on_call).to eq user_1

        advance_time_by 1.day
        expect(schedule.current_user_on_call).to eq user_2

        advance_time_by 1.day
        expect(schedule.current_user_on_call).to eq user_1
      end
    end

    context "weekly rotation" do
      create_schedule(rule: "weekly", users_count: 2)

      it "works with multiple users" do
        expect(schedule.current_user_on_call).to eq user_1

        advance_time_by 1.day
        expect(schedule.current_user_on_call).to eq user_1

        advance_time_by 1.week
        expect(schedule.current_user_on_call).to eq user_2

        advance_time_by 1.week
        expect(schedule.current_user_on_call).to eq user_1
      end
    end

    context "weekly rotation with lots of users" do
      create_schedule(rule: "weekly", users_count: 7)

      it "works with a large number of users" do
        expect(schedule.current_user_on_call).to eq user_1

        advance_time_by 1.week
        expect(schedule.current_user_on_call).to eq user_2

        advance_time_by 1.week
        expect(schedule.current_user_on_call).to eq user_3

        advance_time_by 5.weeks
        expect(schedule.current_user_on_call).to eq user_1
      end
    end

    context "hourly rotation" do
      create_schedule(rule: "hourly", users_count: 3, count: 8)

      it "retrieves the current user on call" do
        expect(schedule.current_user_on_call).to eq user_1

        advance_time_by 8.hours
        expect(schedule.current_user_on_call).to eq user_2

        advance_time_by 8.hours
        expect(schedule.current_user_on_call).to eq user_3

        advance_time_by 8.hours
        expect(schedule.current_user_on_call).to eq user_1
      end
    end
  end
end
