require 'spec_helper'

describe ScheduleLayer do
  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

  describe 'associations' do
    it { should belong_to(:schedule) }
    it { should have_many(:user_schedule_layers) }
    it { should have_many(:users).through(:user_schedule_layers) }
  end

  describe 'validations' do
    it { should ensure_inclusion_of(:rule).in_array(%w[ hourly daily weekly monthly yearly ])}
    it { should validate_presence_of(:count) }
    it { should validate_presence_of(:rule) }
  end

  describe 'callbacks' do
    let(:schedule_layer) { build(:schedule_layer) }

    it 'resets start_at to beginning of day' do
      schedule_layer.should_receive(:reset_start_at_to_beginning_of_day)
      schedule_layer.save
    end

    it 'calculates the duration in seconds' do
      schedule_layer.should_receive(:calculate_duration_in_seconds)
      schedule_layer.save
    end
  end

  describe 'duration calculations' do
    let(:hourly) { create(:schedule_layer, rule: 'hourly', count: 8) }
    let(:daily) { create(:schedule_layer, rule: 'daily') }
    let(:weekly) { create(:schedule_layer, rule: 'weekly') }
    let(:monthly) { create(:schedule_layer, rule: 'monthly') }
    let(:yearly) { create(:schedule_layer, rule: 'yearly') }

    it 'calculates the correct rotation length in seconds' do
      hourly.duration.should be 28800
      daily.duration.should be 86400
      weekly.duration.should be 604800
      monthly.duration.should be 2592000
      yearly.duration.should be 31557600
    end

    it 'can determine the appropriate per-unit duration' do
      hourly.unit_duration.should == 3600
      daily.unit_duration.should == 86400
      weekly.unit_duration.should == 604800
      monthly.unit_duration.should == 2592000
      yearly.unit_duration.should == 31557600
    end
  end

  describe '#user_schedules' do
    create_schedule(rule: 'daily', users_count: 2)

    subject { schedule_layer }

    it { should have(2).users }
    it { should have(2).user_schedules }

    it 'should be an Array of UserSchedule objects' do
      subject.user_schedules.should be_an Array
      subject.user_schedules.first.should be_a UserSchedule
    end
  end

  describe '#user_offset' do
    context 'hourly' do
      create_schedule(rule: 'hourly', users_count: 2, count: 8)

      it do #'returns how long in seconds to offset based on the number of users' do
        schedule_layer.user_offset(user_1).should == 0
        schedule_layer.user_offset(user_2).should == 28800
      end
    end
    context 'daily' do
      create_schedule(rule: 'daily', users_count: 2)

      it do #'returns how long in seconds to offset based on the number of users' do
        schedule_layer.user_offset(user_1).should == 0
        schedule_layer.user_offset(user_2).should == 86400
      end

    end

    context 'weekly' do
        create_schedule(rule: 'weekly', users_count: 2)

      it do #'returns how long in seconds to offset based on the number of users' do
        schedule_layer.user_offset(user_1).should == 0
        schedule_layer.user_offset(user_2).should == 604800
      end
    end
  end

end
