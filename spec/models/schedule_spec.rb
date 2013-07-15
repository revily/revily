require 'spec_helper'

describe Schedule do
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
      obj.to_param.should == obj.uuid
    end
  end

  describe '#current_user_on_call' do
    before { Timecop.freeze(Time.zone.now.beginning_of_day) }
    after { Timecop.return }

    context 'daily rotation' do
      create_schedule(rule: 'daily', users_count: 2)

      it 'works with multiple users' do
        schedule.current_user_on_call.should eq user_1

        Timecop.freeze now + 1.day
        schedule.current_user_on_call.should eq user_2

        Timecop.freeze now + 1.day
        schedule.current_user_on_call.should eq user_1
      end
    end

    context 'weekly rotation' do
      create_schedule(rule: 'weekly', users_count: 2)

      it 'works with multiple users' do
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
      create_schedule(rule: 'weekly', users_count: 7)

      it 'works with a large number of users' do
        schedule.current_user_on_call.should eq user_1

        Timecop.freeze now + 1.week
        schedule.current_user_on_call.should eq user_2

        Timecop.freeze now + 1.week
        schedule.current_user_on_call.should eq user_3

        Timecop.freeze now + 5.weeks
        schedule.current_user_on_call.should eq user_1
      end
    end

    context 'hourly rotation' do
      create_schedule(rule: 'hourly', users_count: 3, count: 8)

      it 'retrieves the current user on call' do
        schedule.current_user_on_call.should eq user_1
        # ap schedule_layer.inspect
        Timecop.freeze now + 8.hours
        schedule.current_user_on_call.should eq user_2

        Timecop.freeze now + 8.hours
        schedule.current_user_on_call.should eq user_3

        Timecop.freeze now + 8.hours
        schedule.current_user_on_call.should eq user_1
      end
    end
  end
end
