require 'spec_helper'

describe UserScheduleLayer do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:schedule_layer) }
  end

  context 'validations' do
    it { should validate_uniqueness_of(:user_id).scoped_to([:schedule_layer_id]) }
    it { should validate_uniqueness_of(:schedule_layer_id).scoped_to([:user_id]) }
  end
end
