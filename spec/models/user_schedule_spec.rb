require 'spec_helper'

describe UserSchedule do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:schedule) { create(:schedule) }
  let(:schedule_layer) { create(:schedule_layer, schedule: schedule, user: user) }
end
