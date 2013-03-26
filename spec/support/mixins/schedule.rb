module ScheduleMixins
  module Macros
    def create_schedule_with_rule_and_users(rule, users_count=1)
      let(:schedule) { create(:schedule_with_layers_and_users, rule: rule, users_count: users_count) }
      let(:schedule_layer) { schedule.schedule_layers.first }

      (1..users_count).each_with_index do |id, index|
        let("user_#{id}") { schedule_layer.users[index] }
      end
    end
  end

  module Helpers
    def now
      Time.zone.now
    end
  end
end