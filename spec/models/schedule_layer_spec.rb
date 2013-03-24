require 'spec_helper'

describe ScheduleLayer do
  context 'associations' do
    it { should belong_to(:schedule) }
    it { should have_many(:user_schedule_layers) }
    it { should have_many(:users).through(:user_schedule_layers) }
  end

  describe 'validations' do
    it { should ensure_inclusion_of(:rule).in_array(%w[ hourly daily weekly monthly yearly ])}
    it { should validate_presence_of(:count) }
    it { should validate_presence_of(:rule) }
  end

  describe '#calculate_rotation_length_in_seconds' do
    let(:hourly) { create(:schedule_layer, rule: 'hourly', count: 8) }
    let(:daily) { create(:schedule_layer, rule: 'daily') }
    let(:weekly) { create(:schedule_layer, rule: 'weekly') }
    let(:monthly) { create(:schedule_layer, rule: 'monthly') }

    it 'calculates the correct rotation length in seconds' do
      hourly.duration.should be 28800
      daily.duration.should be 86400
      weekly.duration.should be 604800
    end
  end

end
