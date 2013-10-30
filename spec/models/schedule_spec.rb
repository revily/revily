require 'spec_helper'

describe Schedule do
  pause_events!

  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

  context 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:schedule_layers) }
    it { should have_many(:user_schedule_layers).through(:schedule_layers) }
    it { should have_many(:users).through(:user_schedule_layers) }
    it { should have_many(:policy_rules) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:time_zone) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      expect(obj.to_param).to eq obj.uuid
    end
  end

  describe '#current_user_on_call' do
    before { Timecop.freeze(Time.zone.now.beginning_of_day) }
    after { Timecop.return }

    context 'daily rotation' do
      create_schedule(rule: 'daily', users_count: 2)

      it 'works with multiple users' do
        expect(schedule.current_user_on_call).to eq user_1

        Timecop.freeze now + 1.day
        expect(schedule.current_user_on_call).to eq user_2

        Timecop.freeze now + 1.day
        expect(schedule.current_user_on_call).to eq user_1
      end
    end

    context 'weekly rotation' do
      create_schedule(rule: 'weekly', users_count: 2)

      it 'works with multiple users' do
        expect(schedule.current_user_on_call).to eq user_1

        Timecop.freeze now + 1.day
        expect(schedule.current_user_on_call).to eq user_1

        Timecop.freeze now + 6.days
        expect(schedule.current_user_on_call).to eq user_2

        Timecop.freeze now + 7.days
        expect(schedule.current_user_on_call).to eq user_1
      end
    end

    context 'weekly rotation with lots of users' do
      create_schedule(rule: 'weekly', users_count: 7)

      it 'works with a large number of users' do
        expect(schedule.current_user_on_call).to eq user_1

        Timecop.freeze now + 1.week
        expect(schedule.current_user_on_call).to eq user_2

        Timecop.freeze now + 1.week
        expect(schedule.current_user_on_call).to eq user_3

        Timecop.freeze now + 5.weeks
        expect(schedule.current_user_on_call).to eq user_1
      end
    end

    context 'hourly rotation' do
      create_schedule(rule: 'hourly', users_count: 3, count: 8)

      it 'retrieves the current user on call' do
        expect(schedule.current_user_on_call).to eq user_1
        # ap schedule_layer.inspect
        Timecop.freeze now + 8.hours
        expect(schedule.current_user_on_call).to eq user_2

        Timecop.freeze now + 8.hours
        expect(schedule.current_user_on_call).to eq user_3

        Timecop.freeze now + 8.hours
        expect(schedule.current_user_on_call).to eq user_1
      end
    end
  end
end
