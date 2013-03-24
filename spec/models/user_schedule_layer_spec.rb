require 'spec_helper'

describe UserScheduleLayer do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:schedule_layer) }
  end
end
