require 'spec_helper'

describe Schedule do
  context 'associations' do
    it { should have_many(:user_schedules) }
    it { should have_many(:users).through(:user_schedules) }
    it { should have_many(:escalation_rules) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:rotation_type) }
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:time_zone) }

    it { should ensure_inclusion_of(:rotation_type).in_array(%w[ daily weekly custom ])}
  end

  context 'attributes' do
    it { should have_readonly_attribute(:uuid) }
  end

  describe '#custom?' do
    let(:weekly_schedule) { create(:weekly_schedule) }
    let(:custom_schedule) { create(:custom_schedule) }

    it 'should be true or false depending on rotation_type' do
      custom_schedule.should be_custom
      weekly_schedule.should_not be_custom
    end

  end
end
