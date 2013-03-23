require 'spec_helper'

describe ScheduleLayer do
  context 'associations' do
    it { should belong_to(:schedule) }
    it { should have_many(:user_schedule_layers) }
    it { should have_many(:users).through(:user_schedule_layers) }
  end

  describe 'validations' do
    it { should ensure_inclusion_of(:type).in_array(%w[ daily weekly custom ])}

    context 'custom rotation type' do
      before { subject.stub(:custom?) { true } }
      it { should validate_presence_of(:count) }
      it { should validate_presence_of(:unit) }
    end

    context "standard rotation type" do
      before { subject.stub(:custom?) { false } }
      it { should_not validate_presence_of(:count) }
      it { should_not validate_presence_of(:unit) }
    end
  end

  describe '#calculate_rotation_length_in_seconds' do
    let(:daily) { create(:daily_schedule_layer) }
    let(:weekly) { create(:weekly_schedule_layer) }
    let(:custom) { create(:custom_schedule_layer) }
    let(:custom2) { create(:custom_schedule_layer, count: 12) }
    let(:custom3) { create(:custom_schedule_layer, count: 1, unit: 'weeks') }

    it 'calculates the correct rotation length in seconds' do
      daily.shift_length.should be 86400
      weekly.shift_length.should be 604800
      custom.shift_length.should be 28800
      custom2.shift_length.should be 43200
      custom3.shift_length.should be 604800
    end
  end

end
