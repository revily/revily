require 'spec_helper'

describe ScheduleBuilder do
  let(:schedule) { create(:schedule_with_layers) }
  let(:schedule_builder) { ScheduleBuilder.new(schedule) }

  describe '#source' do
    it { schedule_builder.source.should be_a(Schedule) }
  end

  describe '#schedules' do
    it { schedule_builder.schedules.should be_an Array }
  end

end
