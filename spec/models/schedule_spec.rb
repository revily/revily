require 'spec_helper'

describe Schedule do
  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

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
    before { Timecop.freeze(Time.zone.now.beginning_of_day) }
    after { Timecop.return }

    context 'daily rotation' do
      create_schedule_with_rule_and_users('daily', 2)

      it 'retrieves the current user on call' do
        schedule.current_user_on_call.should eq user_1

        Timecop.freeze now + 1.day
        schedule.current_user_on_call.should eq user_2

        Timecop.freeze now + 1.day
        schedule.current_user_on_call.should eq user_1
      end
    end

    context 'weekly rotation' do
      create_schedule_with_rule_and_users('weekly', 2)

      it 'retrieves the current user on call' do
        schedule.current_user_on_call.should eq user_1

        Timecop.freeze now + 1.day
        schedule.current_user_on_call.should eq user_1

        Timecop.freeze now + 6.days
        schedule.current_user_on_call.should eq user_2

        Timecop.freeze now + 7.days
        schedule.current_user_on_call.should eq user_1
      end
    end

    context 'weekly rotation with lots of users' do
      create_schedule_with_rule_and_users('weekly', 7)

      it 'retrieves the current user on call' do
        schedule.current_user_on_call.should eq user_1

        Timecop.freeze now + 1.week
        schedule.current_user_on_call.should eq user_2

        Timecop.freeze now + 1.week
        schedule.current_user_on_call.should eq user_3

        Timecop.freeze now + 5.weeks
        schedule.current_user_on_call.should eq user_1
      end
    end
  end
end
