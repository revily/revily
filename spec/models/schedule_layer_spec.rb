require 'spec_helper'

describe ScheduleLayer do
  pause_events!

  extend ScheduleMixins::Macros
  include ScheduleMixins::Helpers

  context 'associations' do
    it { should belong_to(:schedule) }
    it { should have_many(:user_schedule_layers) }
    it { should have_many(:users).through(:user_schedule_layers) }
  end

  context 'validations' do
    it { should ensure_inclusion_of(:rule).in_array(%w[ hourly daily weekly monthly yearly ])}
    it { should validate_presence_of(:count) }
    it { should validate_presence_of(:rule) }
  end

  context 'callbacks' do
    let(:schedule_layer) { build(:schedule_layer) }
    before do
      schedule_layer.stub(
        reset_start_at_to_beginning_of_day: true, 
        calculate_duration_in_seconds: true
      )
    end

    it 'resets start_at to beginning of day' do
      schedule_layer.save
      expect(schedule_layer).to have_received(:reset_start_at_to_beginning_of_day)
    end

    it 'calculates the duration in seconds' do
      schedule_layer.save
      expect(schedule_layer).to have_received(:calculate_duration_in_seconds)
    end
  end

  context 'attributes' do
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      expect(obj.to_param).to eq obj.uuid
    end
  end

  context 'duration calculations' do
    let(:hourly) { create(:schedule_layer, :hourly) }
    let(:daily) { create(:schedule_layer, :daily) }
    let(:weekly) { create(:schedule_layer, :weekly) }
    let(:monthly) { create(:schedule_layer, :monthly) }
    let(:yearly) { create(:schedule_layer, :yearly) }

    it 'calculates the correct rotation length in seconds' do
      expect(hourly.duration).to be 28800
      expect(daily.duration).to be 86400
      expect(weekly.duration).to be 604800
      expect(monthly.duration).to be 2592000
      expect(yearly.duration).to be 31557600
    end

    it 'can determine the appropriate per-unit duration' do
      expect(hourly.unit_duration).to eq 3600
      expect(daily.unit_duration).to eq 86400
      expect(weekly.unit_duration).to eq 604800
      expect(monthly.unit_duration).to eq 2592000
      expect(yearly.unit_duration).to eq 31557600
    end
  end

  describe '#user_schedules' do
    create_schedule(rule: 'daily', users_count: 2)

    subject { schedule_layer }

    it { should have(2).users }
    it { should have(2).user_schedules }

    it 'should be an Array of UserSchedule objects' do
      expect(subject.user_schedules).to be_an Array
      expect(subject.user_schedules.first).to be_a UserSchedule
    end
  end

  describe '#user_offset' do
    context 'hourly' do
      create_schedule(rule: 'hourly', users_count: 2, count: 8)

      it do #'returns how long in seconds to offset based on the number of users' do
        expect(schedule_layer.user_offset(user_1)).to eq 0
        expect(schedule_layer.user_offset(user_2)).to eq 28800
      end
    end
    context 'daily' do
      create_schedule(rule: 'daily', users_count: 2)

      it do #'returns how long in seconds to offset based on the number of users' do
        expect(schedule_layer.user_offset(user_1)).to eq 0
        expect(schedule_layer.user_offset(user_2)).to eq 86400
      end

    end

    context 'weekly' do
        create_schedule(rule: 'weekly', users_count: 2)

      it do #'returns how long in seconds to offset based on the number of users' do
        expect(schedule_layer.user_offset(user_1)).to eq 0
        expect(schedule_layer.user_offset(user_2)).to eq 604800
      end
    end
  end

end
