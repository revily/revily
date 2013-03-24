require 'spec_helper'

describe ScheduleBuilder do
  let(:raw_schedule) { create(:schedule_with_layers) }
  let(:schedule_builder) { ScheduleBuilder.new(raw_schedule) }

  describe '#source' do
    it { schedule_builder.source.should be_a(Schedule) }
  end

  describe '#schedule' do
    it { schedule_builder.schedule.should be_an(IceCube::Schedule)}
  end

end
