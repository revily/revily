require 'spec_helper'

describe UserSchedule do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:schedule) }
  end
end
